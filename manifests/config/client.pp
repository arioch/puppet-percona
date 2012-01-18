class percona::config::client {
  if $percona::client {
    File {
      owner   => $percona::params::user,
      group   => $percona::params::group,
      notify  => Service[$percona::params::service],
      require => Class['percona::install'],
    }
  }
}
