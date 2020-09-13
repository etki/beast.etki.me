require 'etc'
require 'pathname'

registry = Etki::Satellite::Registry.new(node)

interfaces = [1900, 7359].map do |port|
  { port: port, protocol: :udp, address: :lan }
end

groups = %w[video render].map { |name| Etc.getgrnam(name).gid }

satellite_service 'media' do
  image 'emby/embyserver'
  interfaces(interfaces)
  ingress([8096])
  mounts([
    { source: registry.services.state_directory(:media), target: '/config', writable: true },
    { source: '/media/sdb1/Media', target: '/mount/Storage' },
    { source: '/media/sdb1/Cloud/Yandex.Disk/Media/Music', target: '/mount/Storage/Music' },
  ])
  devices(['/dev/dri'])
  environment(GIDLIST: groups.join(','))
end
