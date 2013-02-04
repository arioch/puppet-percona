# Class: percona::install
#
#
class percona::install {
  $server           = $::percona::server
  $client           = $::percona::client
  $cluster          = $::percona::cluster
  $percona_version  = $::percona::percona_version

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      $pkg_version = $percona_version
      if $cluster {
        $pkg_client_default = "percona-xtradb-cluster-client-${pkg_version}"
        $pkg_server_default = "percona-xtradb-cluster-server-${pkg_version}"
        $pkg_common_default = [
          'percona-toolkit',
          "percona-xtradb-cluster-common-${pkg_version}",
        ]
      }
      else {
        $pkg_client_default = "percona-server-client-${pkg_version}"
        $pkg_server_default = "percona-server-server-${pkg_version}"

	# Avoid dependency resolution on version change
        $pkg_common_default = [
          'percona-toolkit',
          $percona_version ? {
            '5.1'   => 'percona-server-common',
            default => "percona-server-common-${pkg_version}",
          },
        ]
      }
    }

    /(?i:redhat|centos)/: {
      $pkg_version = regsubst($percona_version, '\.', '', 'G')

      if $cluster {
        $pkg_client_default = "Percona-XtraDB-Cluster-client"
        $pkg_server_default = "Percona-XtraDB-Cluster-server"
	# The Percona-Compat packages break Cluster-shared.
        if ( $::percona::pkg_compat == false ) {
          $pkg_common_default = [
            'percona-toolkit',
            'Percona-XtraDB-Cluster-shared',
          ]
        }
        else {
          $pkg_common_default = 'percona-toolkit' 
        }
      }
      else {
        $pkg_client_default = "Percona-Server-client-${pkg_version}"
        $pkg_server_default = "Percona-Server-server-${pkg_version}"
        $pkg_common_default = [
          "Percona-Server-shared-${pkg_version}",
          'percona-toolkit',
        ]
      }

      # Installation of Percona's shared compatibility libraries
      case $percona_version {
        '5.5': {
          $pkg_compat = $::percona::pkg_compat ? {
            undef    => 'Percona-Server-shared-compat',
            false    => '',
            default  => $::percona::pkg_compat,
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
#        fail("package is $pkg_compat")

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

