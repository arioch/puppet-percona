# Class: percona::install
#
#
class percona::install {
  $server           = $::percona::server
  $client           = $::percona::client
  $percona_version  = $::percona::percona_version

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      $pkg_version = $percona_version
      $pkg_client  = "percona-server-client-${pkg_version}"
      $pkg_server  = "percona-server-server-${pkg_version}"
      $pkg_common  = [
        'percona-toolkit',
        "percona-server-common-${pkg_version}"
      ]
    }

    /(?i:redhat|centos)/: {
      $pkg_version = $percona_version ? {
        '5.1'   => '51',
        '5.5'   => '55',
        default => regsubst($percona_version, '\.', '', 'G'),
      }

      $pkg_client = "Percona-Server-client-${pkg_version}"
      $pkg_server = "Percona-Server-server-${pkg_version}"
      $pkg_compat = 'Percona-Server-shared-compat'
      $pkg_common = [
        "Percona-Server-shared-${pkg_version}",
        'percona-toolkit'
      ]
    }

    default: {
      fail('Operating system not supported yet.')
    }
  }

  Package {
    require => [
      Class['percona::preinstall']
    ],
  }

  # Installation of Percona's shared compatibility libraries
  case $percona_version {
    '5.5': {
      package { $pkg_compat:
        ensure => 'present',
        before => Package[$pkg_common];
      }
    }
    default: {
    }
  }

  # Installation of Percona's shared libraries
  package { $pkg_common:
    ensure => 'present';
  }

  # Installation of the Percona client
  if $::percona::client {
    package { $pkg_client:
      ensure  => 'present',
      require => Package[$pkg_common],
    }
  }

  # Installation of the Percona server
  if $::percona::server {

    package { $pkg_server:
      ensure  => 'present',
      require => [
        Package[$pkg_client],
        Package[$pkg_common]
      ],
    }
  }
}

