credentials = data_bag_item('credentials', 'yandex-disk')

include_recipe 'ayte-yandex-disk::install'

authentication_file = '/etc/yandex/disk/authentication'
configuration_file = '/etc/yandex/disk/configuration.ini'

yandex_disk_auth authentication_file do
  username credentials['user']
  password credentials['password']
end

yandex_disk_configuration configuration_file do
  storage_path '/media/sdb1/Cloud/Yandex.Disk'
  auth_file_path authentication_file
end

systemd_unit 'yandex-disk.service' do
  command = [
    '/usr/bin/yandex-disk',
    'start',
    '--config',
    configuration_file
  ]

  content(
    Unit: {
      Description: 'Starts Yandex disk',
      Wants: 'usb-mount@sdb1.service'
    },
    Service: {
      Type: 'forking',
      ExecStart: command.map { |entry| Shellwords.escape(entry) }.join(' ')
    }
  )
  action [:create, :enable, :start]
end
