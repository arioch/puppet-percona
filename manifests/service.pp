# == Class: percona::service
#
# Enabled the (mysql) service
#
class percona::service {
  $service_name   = $percona::service_name
  $service_enable = $percona::service_enable
  $service_ensure = $percona::service_ensure

  if $::percona::server {
    service { $service_name:
      ensure  => $service_ensure,
      enable  => $service_enable,
      require => Class['percona::config'],
    }
  }
}
