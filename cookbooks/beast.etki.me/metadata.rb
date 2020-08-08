name 'beast.etki.me'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures beast.etki.me'
long_description 'Installs/Configures beast.etki.me'
version '0.1.0'
chef_version '>= 14.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/beast.etki.me/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/beast.etki.me'

depends 'apt', '> 7.0.0'
depends 'apt_cleanup', '~> 0.1.0'
depends 'docker', '~> 6.0.3'
depends 'ayte-yandex-disk'
