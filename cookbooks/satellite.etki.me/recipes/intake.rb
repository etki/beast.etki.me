registry = Etki::Satellite::Registry.new(node)

local_configuration_file_path = registry.services.configuration_path(:transmission, 'settings.json')

hosts = [
  registry.services.private_address(:transmission),
  "*.#{registry.machine.advertised_name}"
]

template local_configuration_file_path do
  source 'intake/distributed/settings.json.erb'
  variables(hosts: hosts)
  notifies :restart, 'satellite_service[distributed.intake]', :immediately
end

satellite_service 'distributed.intake' do
  image 'linuxserver/transmission'
  interfaces([
    { port: 51413, protocol: :udp },
    { port: 51413, protocol: :tcp }
  ])
  ingress([{ port: 9091, secured: true }])
  mounts([
    { source: '/media/sdb1/Downloads/Torrents', target: '/downloads', writable: true },
    { source: registry.services.state_path('distributed.intake', :configuration), target: '/config', writable: true },
    { source: local_configuration_file_path, target: '/config/settings.json', writable: false },
    { source: registry.services.state_path('distributed.intake', :watch), target: '/watch', writable: false }
  ])

  action :run
end
