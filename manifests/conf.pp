define percona::conf (
  $content,
  $ensure = present
) {
  file { "${percona::confdir}/conf.d/${name}.cnf":
    ensure  => $ensure,
    owner   => $percona::config_user,
    group   => $percona::config_group,
    mode    => '0600',
    content => $content,
    require => Class['percona::config'],
    notify  => Service[$percona::service_name],
  }
}
