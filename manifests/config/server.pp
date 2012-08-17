# config/server.pp

class percona::config::server {
  $server  = $::percona::server
  $user    = $::percona::user
  $group   = $::percona::group
  $confdir = $::percona::confdir

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
