# Class: percona::service
#
#
class percona::service {
  $service = $::percona::service

  service { $service:
    ensure  => 'running',
    enable  => true,
    require => Class['percona::config'],
  }
}
