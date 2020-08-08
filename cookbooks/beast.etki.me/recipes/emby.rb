directory '/var/emby/configuration' do
  recursive true
end

docker_image 'emby/embyserver'

docker_container 'emby' do
  repo 'emby/embyserver'
  volumes %w[
    /var/emby/configuration:/config
    /media/sdb1/Music:/mnt/Music
    /media/sdb1/Video:/mnt/Video
  ]
  network_mode 'host'

  action %i[create start]
end
