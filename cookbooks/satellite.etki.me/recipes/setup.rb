apt_update
include_recipe 'apt::unattended-upgrades'
include_recipe 'apt_cleanup::remove_unneeded_packages'
include_recipe 'apt_cleanup::remove_old_kernels'

package 'certbot'
