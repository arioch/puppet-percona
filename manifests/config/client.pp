# = Class: percona::config::client
#
#
class percona::config::client {
  $client       = $::percona::client
  $config_user  = $::percona::config_user
  $config_group = $::percona::config_group
  $service_name = $::percona::service_name

  if $client {
    File {
      owner   => $config_user,
      group   => $config_group,
      notify  => Service[$service_name],
      require => Class['percona::install'],
    }
  }
}
