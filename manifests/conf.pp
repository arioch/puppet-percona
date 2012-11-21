# == Class percona::conf
#
# Magage configuration snippets. in /etc/mysql/conf.d/
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
  $config_includedir = $percona::config_includedir
  $config_file_mode  = $percona::config_file_mode
  $config_group      = $percona::config_group
  $config_user       = $percona::config_user
  $service_name      = $percona::service_name
  $service_restart   = $percona::service_restart

  if ! $config_includedir {
    fail ('You must specify the config_include_dir parameter in percona or percona::params')
  }

  file { "${config_includedir}/${name}.cnf":
    ensure  => $ensure,
    owner   => $config_user,
    group   => $config_group,
    mode    => $config_file_mode,
    content => $content,
    require => Class['percona::config::server'],
  }

  if $service_restart {
    File {
      notify  => Service[$service_name],
    }
  }
}
