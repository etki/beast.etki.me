# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 13-09-2020

### Changed

- Transmission was upgraded to docker service.
- Single user database was introduced to protect services like 
transmission using basic auth.
- Media server is now exposed as `media.satellite.etki.me`

## [0.1.1] - 13-09-2020

### Changed

- Renamed from `beast.etki.me` to `satellite.etki.me`
- Emby address is now `media.entertainment.<domain>`

### Added

- Added `satellite_service` and `satellite_container` resources /
abstractions
- Added some classes to replace hash traversals
- Added `satellite_ingress` to proxy specific HTTP services
- Added certbot integration for proxied services

## [0.1.0] - 09-08-2020

Initial release: Emby & Transmission
