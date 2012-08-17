# = Class: percona::config::client
#
#
#
# == Todo:
#
# * Document what this class does.
#
class percona::config::client {
  $client  = $::percona::client
  $user    = $::percona::user
  $group   = $::percona::group
  $service = $::percona::service

  if $client {
    File {
      owner   => $user,
      group   => $group,
      notify  => Service[$service],
      require => Class['percona::install'],
    }
  }
}
