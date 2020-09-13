require 'pathname'

resource_name :satellite_container

property :image, String, required: true
property :host_name, String, required: false
property :interfaces, Array, default: []
property :mounts, Array, default: []
property :devices, Array, default: []
property :environment, Hash, default: {}
property :networks, Array, default: []

default_action :run

action :run do
  registry = Etki::Satellite::Registry.new(node)

  docker_image new_resource.image do
    tag registry.containers.tag(image)
  end

  # @type [Etki::Satellite::Service::Forwarding] forwarding
  ports = new_resource.interfaces.map do |forwarding|
    forwarding = Etki::Satellite::Service::Forwarding.normalize(forwarding)
    target_port = forwarding.target.port || forwarding.source.port
    parts = [forwarding.source.port, target_port]

    if forwarding.target.address
      address = forwarding.target.address
      address = registry.machine.local_address if address == :lan
      parts.prepend(address)
    end
    protocol = forwarding.source.protocol == :udp ? :udp : :tcp

    "#{parts.join(':')}/#{protocol}"
  end

  # @type [Etki::Satellite::Service::Mount] configuration
  volumes = new_resource.mounts.map do |configuration|
    parts = [configuration.source, configuration.target]
    parts.append('ro') unless configuration.writable
    parts.join(':')
  end

  devices = new_resource.devices.flat_map do |entry|
    mount = Etki::Satellite::Service::Mount.normalize(entry)
    raise entry.inspect if mount.source.nil?

    pairs = if ::File.directory?(mount.source)
      Pathname.new(mount.source).children
        .reject(&:directory?)
        .map do |path|
          {
            source: path,
            target: Pathname.new(mount.target).join(path.basename)
          }
        end
    else
      [{ source: path, target: target }]
    end

    pairs.map do |pair|
      {
        'PathOnHost' => pair[:source].to_s,
        'PathInContainer' => pair[:target].to_s,
        'CgroupPermissions' => 'rwm'
      }
    end
  end

  docker_container new_resource.name do
    repo new_resource.image
    tag registry.containers.tag(new_resource.image)
    host_name(new_resource.host_name) if new_resource.host_name
    port ports
    volumes volumes
    devices devices
    env(new_resource.environment.map { |key, value| "#{key}=#{value}" })

    restart_policy 'unless-stopped'
    action :run
  end

  new_resource.networks.each do |network_name|
    docker_network network_name do
      container new_resource.name
      action %i[create connect]
    end
  end
end

%i[reload delete].each do |action_name|
  action action_name do
    docker_container new_resource.name do
      action action_name
    end
  end
end
