lookup = Etki::Satellite::Registry.new(node)

docker_service 'default' do
  action %i[create start]
end

docker_network lookup.containers.qualified_network_name

docker_network 'passthrough' do
  driver 'macvlan'
end

