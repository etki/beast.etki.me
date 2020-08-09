#
# Cookbook:: beast.etki.me
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

# class Chef::Resource::Directory
#   def apt_installed?
#     true
#   end
# end

apt_update
include_recipe 'apt::unattended-upgrades'
include_recipe 'apt_cleanup::remove_unneeded_packages'
include_recipe 'apt_cleanup::remove_old_kernels'

include_recipe 'beast.etki.me::docker'
include_recipe 'beast.etki.me::mount'
include_recipe 'beast.etki.me::yandex-disk'
include_recipe 'beast.etki.me::emby'
include_recipe 'beast.etki.me::transmission'
