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
      $pkg_client_default = "percona-server-client-${pkg_version}"
      $pkg_server_default = "percona-server-server-${pkg_version}"

      case $percona_version {
        '5.1': {
          $pkg_common_default = [
            'percona-toolkit',
            "percona-server-common"
          ]
        }

        default: {
          $pkg_common_default = [
            'percona-toolkit',
            "percona-server-common-${pkg_version}"
          ]
        }
      }
    }

    /(?i:redhat|centos)/: {
      $pkg_version = regsubst($percona_version, '\.', '', 'G')

      $pkg_client_default = "Percona-Server-client-${pkg_version}"
      $pkg_server_default = "Percona-Server-server-${pkg_version}"
      $pkg_common_default = [
        "Percona-Server-shared-${pkg_version}",
        'percona-toolkit'
      ]

      # Installation of Percona's shared compatibility libraries
      case $percona_version {
        '5.5': {
          $pkg_compat = $::percona::pkg_compat ? {
            undef   => 'Percona-Server-shared-compat',
            default => $::percona::pkg_compat,
          }
        }
        default: {
          $pkg_compat = $::percona::pkg_compat ? {
            undef   => 'Percona-SQL-shared-compat',
            default => $::percona::pkg_compat,
          }
        }
      }
    }

    default: {
      fail('Operating system not supported yet.')
    }
  }

  $pkg_client = $::percona::pkg_client ? {
    undef   => $pkg_client_default,
    default => $::percona::pkg_client,
  }
  $pkg_server = $::percona::pkg_server ? {
    undef   => $pkg_server_default,
    default => $::percona::pkg_server,
  }
  $pkg_common = $::percona::pkg_common ? {
    undef   => $pkg_common_default,
    default => $::percona::pkg_common,
  }

  Package {
    require => [
      Class['percona::preinstall']
    ],
  }

  # Installation of Percona's shared libraries
  package { $pkg_common:
    ensure => 'present',
  }

  if $pkg_compat {
    package {$pkg_compat:
      ensure => 'present',
      before => Package[$pkg_common],
    }
  }

  # Installation of the Percona client
  if ($client or $server) {
    package { $pkg_client:
      ensure  => 'present',
      require => Package[$pkg_common],
    }
  }

  # Installation of the Percona server
  if $server {
    package { $pkg_server:
      ensure  => 'present',
      require => [
        Package[$pkg_client],
        Package[$pkg_common],
      ],
    }
  }

}

