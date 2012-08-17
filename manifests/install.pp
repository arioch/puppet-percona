# Class: percona::install
#
#
class percona::install {

  require percona::params
  $pkg_common     = $::percona::params::pkg_common
  $pkg_client     = $::percona::params::pkg_client
  $pkg_server     = $::percona::params::pkg_server
  $config         = $::percona::params::config
  $server         = $::percona::params::server
  $client         = $::percona::params::client
  $template       = $::percona::params::template
  $config_content = $::percona::params::config_content
  $logdir         = $::percona::params::logdir

  Package {
    require => [
      Class['percona::preinstall']
    ],
  }

  package {$pkg_common:
    ensure => 'installed';
  }

  ## Log Directory ##

  file { $logdir :
    ensure => 'directory',
    owner  => 'mysql',
    group  => 'mysql',
    mode   => '0750',
  }

  ## Config file ##
  file {$config:
    ensure => 'present',
  }
  # Use provided content or default/overriden template.
  if $config_content {
    File[$config] {
      content => $config_content,
    }
  }
  else {
    File[$config] {
      content => template($template),
    }
  }

  # Installation of the Percona client
  if $client {
    package {$pkg_client:
      ensure  => 'installed',
      require => Package[$pkg_common],
    }
    Package[$pkg_client] -> File[$logdir]
  }
  # Installation of the Percona server
  if $server {
    package {$pkg_server:
      ensure  => 'installed',
      require => Package[$pkg_client],
    }
    Package[$pkg_server] -> File[$logdir]
  }

}
