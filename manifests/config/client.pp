# = Class: percona::config::client
#
#
#
# == Todo:
#
# * Document what this class does.
#
class percona::config::client {
  require percona::params
  $client  = $::percona::params::client
  $user    = $::percona::params::user
  $group   = $::percona::params::group
  $service = $::percona::params::service

  if $client {
    File {
      owner   => $user,
      group   => $group,
      notify  => Service[$service],
      require => Class['percona::install'],
    }
  }
}
