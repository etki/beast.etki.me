resource_name :satellite_service

property :image, String, required: true
property :interfaces, Array, default: []
property :ingress, Array, default: []
property :public_address, [String, NilClass], required: false
property :private_address, [String, NilClass], required: false
property :mounts, Array, default: []
property :devices, Array, default: []
property :environment, Hash, default: {}
property :networks, Array, required: false

default_action :run

action_class do
  def registry
    Etki::Satellite::Registry.new(node)
  end

  def name
    new_resource.name
  end

  def configuration_directory
    registry.services.configuration_directory(name)
  end

  def workspace_directory
    registry.services.workspace_directory(name)
  end

  def public_address
    new_resource.public_address || registry.services.public_address(name)
  end

  def private_address
    new_resource.private_address || registry.services.private_address(name)
  end

  # @return [Pathname]
  def ingress_workspace
    registry.services.workspace_path(name, :ingress)
  end

  # @return [Pathname]
  def certificate_directory
    registry.services.workspace_path(name, :certificates)
  end

  def active_certificate_directory
    certificate_directory.join('live').join(public_address)
  end

  def state_directory
    registry.services.workspace_path(name, :state)
  end

  def network_names
    new_resource.networks || [registry.containers.qualified_network_name]
  end
end

action_mapping = { run: :create }

%i[run delete].each do |action_name|
  action action_name do
    common_action = action_mapping.fetch(action_name, action_name)
    service = Etki::Satellite::Service.new.tap do |instance|
      instance.name = new_resource.name
      instance.public_address = public_address
      instance.private_address = private_address
      instance.ingress = new_resource.ingress
      instance.interfaces = new_resource.interfaces
      instance.mounts = new_resource.mounts
      instance.devices = new_resource.devices
      instance.configuration_directory = configuration_directory
      instance.workspace_directory = workspace_directory
      instance.state_directory = state_directory
      instance.certificate_directory = certificate_directory
      instance.active_certificate_directory = active_certificate_directory
      instance.ingress_workspace_directory = ingress_workspace
    end
    service.normalize!

    directories = [
      configuration_directory,
      active_certificate_directory,
      ingress_workspace,
      state_directory
    ]

    directories.map(&:to_s).each do |name|
      directory name do
        recursive true
        action common_action
        mode '0755'
      end
    end

    certificate_mapping = {
      'chain.pem' => 'satellite.etki.me',
      'fullchain.pem' => 'satellite.etki.me',
      'privkey.pem' => 'satellite.etki.me.key'
    }

    certificate_mapping.each do |target, source|
      path = "#{certificate_directory}/live/#{service.public_address}/#{target}"

      directory Pathname.new(path).parent.to_s do
        recursive true
      end

      cookbook_file path do
        source "certificates/#{source}"
        manage_symlink_source false
        action :create_if_missing
      end
    end

    satellite_container service.name do
      host_name service.public_address
      image new_resource.image
      interfaces service.interfaces
      mounts service.mounts
      networks network_names
      devices service.devices
      environment new_resource.environment

      action action_name
    end

    unless service.ingress.empty?
      edit_resource(:satellite_ingress, 'default') do
        services(services + [service])
      end
    end

    certbot_action = service.ingress.any?(&:https_access) ? :create : :delete

    systemd_name = Etki::Satellite::Constants.name(service.public_address, :certbot)

    email = data_bag_item('credentials', 'letsencrypt')['email']

    systemd_command = [
      'docker run --rm',
      "-v #{service.ingress_workspace_directory}:/var/workspace",
      "-v #{service.certificate_directory}:/etc/letsencrypt",
      'certbot/certbot certonly',
      '--non-interactive --expand',
      '--webroot -w /var/workspace',
      "-d #{service.public_address}",
      "--agree-tos --email #{email}"
    ]

    systemd_unit "#{systemd_name}.service" do
      content(
        Unit: {
          Description: "Certificate renewal for #{service.public_address}"
        },
        Service: {
          Type: 'oneshot',
          ExecStart: systemd_command.join(' '),
          # Cleanup of fake certificates required for nginx to start
          ExecStartPre: "find #{service.active_certificate_directory} -type f -name *.pem -exec rm {} \\;"
        }
      )
      action certbot_action
    end

    systemd_timer systemd_name do
      timer_on_calendar '*-*-* 07:00:00'
      action certbot_action
    end
  end
end

action :reload do
  satellite_container new_resource.name do
    image new_resource.image
    action :reload
  end
end
