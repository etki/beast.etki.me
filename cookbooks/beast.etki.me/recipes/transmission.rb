package 'transmission-daemon'

service 'transmission-daemon' do
  action :nothing
end

credentials = data_bag_item('credentials', 'transmission')

template '/etc/transmission-daemon/settings.json' do
  source 'transmission.json.erb'
  variables(
    download_dir: '/media/sdb1/Downloads/Torrents',
    user: credentials['user'],
    password: credentials['password']
  )
  notifies :reload, 'service[transmission-daemon]', :immediately
  notifies :restart, 'service[transmission-daemon]', :immediately
end
