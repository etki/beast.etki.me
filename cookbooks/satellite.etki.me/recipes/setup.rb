apt_update
include_recipe 'apt::unattended-upgrades'
include_recipe 'apt_cleanup::remove_unneeded_packages'
include_recipe 'apt_cleanup::remove_old_kernels'

package 'certbot'

chef_gem 'htauth'

registry = Etki::Satellite::Registry.new(node)

data_bag('users').each do |id|
  user = data_bag_item('users', id)
  raise "User #{id} has no password specified" unless user['password']

  htpasswd registry.paths.configuration.join('users.htpasswd').to_s do
    user id
    password user['password']
  end
end
