# Class: percona::install
#
#
class percona::install {
  $pkg_common     = $::percona::pkg_common
  $pkg_client     = $::percona::pkg_client
  $pkg_server     = $::percona::pkg_server
  $server         = $::percona::server
  $client         = $::percona::client
  $template       = $::percona::template
  $logdir         = $::percona::logdir

  Package {
    require => [
      Class['percona::preinstall']
    ],
  }

  package { $pkg_common:
    ensure => 'present';
  }

  # Installation of the Percona client
  if $client {
    package { $pkg_client:
      ensure  => 'present',
      require => Package[$pkg_common],
    }
  }

  # Installation of the Percona server
  if $server {
    package { $pkg_server:
      ensure  => 'present',
      require => Package[$pkg_client],
    }
  }
}
