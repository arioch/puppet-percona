define percona::conf (
  $content,
  $ensure = present
) {
  file { "${percona::params::confdir}/conf.d/${name}.cnf":
    ensure  => $ensure,
    owner   => $percona::params::user,
    group   => $percona::params::group,
    mode    => '0600',
    content => $content,
    require => Class['percona::config'],
    notify  => Service[$percona::params::service],
  }
}
