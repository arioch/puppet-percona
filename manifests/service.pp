# Class: percona::service
#
#
class percona::service {
  Service {
    require => Class['percona::config'],
    enable  => true,
  }

  if $percona::server {
    service {
      $percona::params::service:
        ensure => running,
        enable => true,
    }
  }
}
