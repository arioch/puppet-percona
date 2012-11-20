# = Class: percona::config::server
#
#
class percona::config::server {
  $config_content   = $::percona::config_content
  $config_dir       = $::percona::config_dir
  $config_dir_mode  = $::percona::config_dir_mode
  $config_file      = $::percona::config_file
  $config_file_mode = $::percona::config_file_mode
  $config_group     = $::percona::config_group
  $config_user      = $::percona::config_user
  $logdir           = $::percona::logdir
  $server           = $::percona::server
  $service_name     = $::percona::service_name
  $template         = $::percona::template

  File {
    owner   => $config_user,
    group   => $config_group,
    require => Class['percona::install'],
    notify  => Service[$service_name],
  }

  if $config_dir {
    file { $config_dir:
      ensure => 'directory';
    }
  }

  file { $logdir :
    ensure => 'directory',
    owner  => $config_user,
    group  => $config_group,
    mode   => $config_dir_mode,
  }

  ## Config file ##
  file { $config_file:
    ensure => 'present',
    mode   => $config_file_mode,
  }

  # Use provided content or default/overriden template.
  if $config_content {
    File[$config_file] {
      content => $config_content,
    }
  }
  else {
    File[$config_file] {
      content => template($template),
    }
  }
}

