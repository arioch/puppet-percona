# database.pp

define percona::database (
  $ensure
) {

  require percona::params

  if $::mysql_uptime != 0 {
    mysql_database { $name:
      ensure  => $ensure,
      require => File[$::percona::params::config],
    }
  }
}
