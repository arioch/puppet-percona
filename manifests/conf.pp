# == Class percona::conf
#
# Magage configuration snippets. in /etc/mysql/conf.d/
# Currently only configured for debian...
#
# === Todo:
#
# TODO: Document / add example.
# TODO: Check if the main template supports it or throw error.
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
  $service_restart  = $percona::service_restart

  file { "${percona::config_dir}/conf.d/${name}.cnf":
    ensure  => $ensure,
    owner   => $config_user,
    group   => $config_group,
    mode    => $config_file_mode,
    content => $content,
    require => Class['percona::config'],
  }
  if $service_restart {
    File {
      notify  => Service[$service_name],
    }
  }
}
