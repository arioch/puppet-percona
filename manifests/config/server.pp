# == Class: percona::config::server
#
# === Todo:
#
# TODO: Document class.
#
class percona::config::server {
  $config_content   = $::percona::config_content
  $config_dir       = $::percona::config_dir
  $config_dir_mode  = $::percona::config_dir_mode
  $config_file      = $::percona::config_file
  $config_file_mode = $::percona::config_file_mode
  $config_group     = $::percona::config_group
  $config_user      = $::percona::config_user
  $config_includedir = $::percona::config_includedir

  $config_skip      = $::percona::config_skip
  $config_replace   = $::percona::config_replace

  $logdir           = $::percona::logdir
  $server           = $::percona::server
  $service_name     = $::percona::service_name
  $template         = $::percona::template
  $service_restart  = $::percona::service_restart


  File {
    owner   => $config_user,
    group   => $config_group,
    require => [
      Class['percona::install'],
    ],
  }
  if $restart_service {
    File {
      notify => Service[$service_name],
    }
  }

  # Use provided content or default/overriden template.
  if $config_content {
    $file_content = $config_content
  }
  else {
    $file_content = template($template)
  }

  ## Required directories.
  # Only certain distros use a config_dir.
  if $config_dir {
    file { $config_dir:
      ensure => 'directory';
    }
  }


  # We have a config_include_dir configured and it doesnt exist yet:
  # try to create it.
  if $config_includedir and ! (defined(File[$config_includedir])) {
    file {$config_includedir:
      ensure => 'directory',
      mode   => $config_dir_mode,
    }
    # Little trick, if the include folder is a subfolder of config_dir, we will
    # add a dependency on it :)
    if regsubst($config_includedir, "^${config_dir}", '__MATCH__')  =~ /^__MATCH__/ {
      File[$config_includedir] {
        require => File[$config_dir],
      }
    }
  }
  file { $logdir :
    ensure => 'directory',
    mode   => $config_dir_mode,
  }

  if $config_skip != true {
    file { $config_file:
      ensure  => 'present',
      mode    => $config_file_mode,
      content => $file_content,
      replace => $config_replace,
    }
  }

}

