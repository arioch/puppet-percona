# Class percona::conf
#
#
define percona::conf (
  $content,
  $ensure = present
) {
  $config_dir       = $percona::config_dir
  $config_file_mode = $percona::config_file_mode
  $config_group     = $percona::config_group
  $config_user      = $percona::config_user
  $service_name     = $percona::service_name

  file { "${percona::config_dir}/conf.d/${name}.cnf":
    ensure  => $ensure,
    owner   => $cona::config_user,
    group   => $cona::config_group,
    mode    => $cona::config_file_mode,
    content => $content,
    require => Class['percona::config'],
    notify  => Service[$service_name],
  }
}
