resource_name :satellite_ingress
provides :satellite_ingress

property :services, Array, default: []

default_action :nothing

action_mapping = { run: :create }

%i[run delete].each do |action_name|
  action action_name do
    common_action = action_mapping.fetch(action_name, action_name)
    registry = Etki::Satellite::Registry.new(node)
    configuration_directory = registry.services.configuration_directory(:ingress)
    configuration_override_directory = configuration_directory.join('override')
    vhosts_directory = configuration_directory.join('vhosts.d')
    default_vhost = vhosts_directory.join('@.vhost')
    public_address = registry.services.public_address(:ingress)

    [vhosts_directory, configuration_override_directory].each do |path|
      directory path.to_s do
        recursive true
      end
    end

    cookbook_file configuration_override_directory.join('adjustment.conf').to_s do
      source 'ingress/adjustment.conf'
      action common_action
    end

    directory vhosts_directory do
      recursive true
      action common_action
    end

    cookbook_file default_vhost.to_s do
      source 'ingress/vhosts.d/@.vhost'
      action common_action
    end

    user_database = '/etc/nginx/users.htpasswd'

    mounts = [
      { source: configuration_override_directory, target: '/etc/nginx/conf.d' },
      { source: vhosts_directory, target: '/etc/nginx/vhosts.d' },
      { source: registry.paths.configuration.join('users.htpasswd'), target: user_database }
    ]

    # @type [Etki::Satellite::Service] service
    new_resource.services.each do |service|
      certificate_directory = "/var/vhosts.d/#{service.public_address}/certificates"
      webroot = "/var/vhosts.d/#{service.public_address}/www"
      mounts.append(
        { source: service.certificate_directory, target: certificate_directory },
        { source: service.ingress_workspace_directory, target: webroot }
      )

      template vhosts_directory.join("#{service.public_address}.vhost").to_s do
        source 'ingress/@.vhost.erb'
        variables(
          service: service,
          certificate_directory: certificate_directory,
          webroot: webroot,
          user_database: user_database
        )
        notifies :reload, "satellite_container[#{registry.services.public_address(:ingress)}]", :delayed
      end
    end

    systemd_name = Etki::Satellite::Constants.name(:ingress, :reload)
    systemd_unit "#{systemd_name}.service" do
      content(
        Unit: {
          Description: 'Reloads ingress container so it would eventually pick up certificate changes'
        },
        Service: {
          Type: 'oneshot',
          ExecStart: "docker kill -s HUP #{public_address}"
        }
      )
      action common_action
    end

    systemd_timer systemd_name do
      timer_on_calendar '*-*-* 08:00:00'
      action common_action
    end

    satellite_container public_address do
      image 'nginx'
      interfaces([80, 443])
      mounts(mounts.map { |mount| Etki::Satellite::Service::Mount.normalize(mount) })
      networks [registry.containers.qualified_network_name]

      action action_name
    end
  end
end
