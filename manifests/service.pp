# Class: percona::service
#
#
class percona::service {

  require percona::params
  $service = $::percona::params::service

  service { $service:
    ensure  => 'running',
    enable  => true,
    require => Class['percona::config'],
  }
}
