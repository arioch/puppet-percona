# config/server.pp

class percona::config::server {
  require percona::params
  $server  = $::percona::params::server
  $user    = $::percona::params::user
  $group   = $::percona::params::group
  $confdir = $::percona::params::confdir

  if $server {
    File {
      owner   => $user,
      group   => $group,
      require => Class['percona::install'],
    }

    if $confdir {
      file { $confdir:
        ensure => 'directory';
      }
    }
  }
}
