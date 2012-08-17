define percona::conf (
  $content,
  $ensure = present
) {
  file { "${percona::confdir}/conf.d/${name}.cnf":
    ensure  => $ensure,
    owner   => $percona::user,
    group   => $percona::group,
    mode    => '0600',
    content => $content,
    require => Class['percona::config'],
    notify  => Service[$percona::service],
  }
}
