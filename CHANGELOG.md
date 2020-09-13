# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
