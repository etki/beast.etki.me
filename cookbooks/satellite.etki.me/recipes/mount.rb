package 'pmount'

systemd_unit 'usb-mount@.service' do
  content(
    Unit: {
      Description: 'Mount USB Drive on %i'
    },
    Service: {
      Type: 'oneshot',
      RemainAfterExit: true,
      ExecStart: '/usr/bin/pmount --umask 000 /dev/%i /media/%i',
      ExecStop: '/usr/bin/pumount /dev/%i'
    }
  )
  triggers_reload true
  action [:create, :enable]
end

execute 'udev trigger' do
  action :nothing
  command '/bin/udevadm trigger'
end

cookbook_file '/etc/udev/rules.d/99-usb-mount.rules' do
  source 'mount/udev.rules'
  notifies :run, 'execute[udev trigger]'
end
