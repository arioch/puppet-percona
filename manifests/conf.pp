define percona::conf (
  $content,
  $ensure = present
) {
  file { "${percona::config_dir}/conf.d/${name}.cnf":
    ensure  => $ensure,
    owner   => $percona::config_user,
    group   => $percona::config_group,
    mode    => $percona::config_file_mode,
    content => $content,
    require => Class['percona::config'],
    notify  => Service[$percona::service_name],
  }
}
