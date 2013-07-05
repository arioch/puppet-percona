# == Class: percona::config::server
#
# === Todo:
#
# TODO: Document class.
#
class percona::config::server {
  $config_content    = $::percona::config_content
  $config_dir        = $::percona::config_dir
  $config_dir_mode   = $::percona::config_dir_mode
  $config_file       = $::percona::config_file
  $config_file_mode  = $::percona::config_file_mode
  $config_group      = $::percona::config_group
  $config_includedir = $::percona::config_includedir
  $config_user       = $::percona::config_user

  $config_replace   = $::percona::config_replace
  $config_skip      = $::percona::config_skip

  $daemon_user      = $::percona::daemon_user
  $logdir           = $::percona::logdir
  $logdir_group     = $::percona::logdir_group
  $server           = $::percona::server
  $service_name     = $::percona::service_name
  $service_restart  = $::percona::service_restart
  $template         = $::percona::template
  $version          = $::percona::percona_version

  $configuration         = $::percona::configuration
  $default_configuration = $::percona::params::default_configuration

  File {
    owner   => $config_user,
    group   => $config_group,
    require => [
      Class['percona::install'],
    ],
  }
  if $service_restart {
    File {
      notify => Service[$service_name],
    }
  }

  # Workaround for assigning an empty hash. Puppet doesn't know how to
  # handle {} very well in certain places.
  $empty_hash = {}


  # Get the hash that is global (all versions).
  if $default_configuration['global'] {
    $default_global = $default_configuration['global']
  } else {
    $default_global = {}
  }

  # Get the hash for the version we are installing.
  if $default_configuration[$version] {
    $default_version = $default_configuration[$version]
  } else {
    $default_version = {}
  }


  # Configuration set on the percona class level.
  $my_configuration = $configuration ? {
    undef   => $empty_hash,
    default => $configuration,
  }

  # A part of the configuration is created from various parameters that have
  # been defined on percona::params or percona.
  $params           = $::percona::params

  # Globals
  if $params['global'] {
    $params_global = $params['global']
  } else {
    $params_global = {}
  }
  # Version specifics.
  if $params[$version] {
    $params_version = $params[$version]
  } else {
    $params_version = {}
  }

  # Special case. Only add this parameter if it has been set. We need to do
  # this like this because we can not adjust the params hash after it has been
  # defined.
  if $::percona::tmpdir {
    $tempdir = { 'tmpdir' => $::percona::tmpdir, }
  } else {
    $tempdir = {}
  }

  # these are all the hashes we are going to merge. The my_configuration is the
  # most specific (its stuff WE have set) and others will be used as 'defaults'
  $hashes = [
    $default_version,
    $default_global,
    $params_version,
    $params_global,
    $tempdir,
  ]

  # One big hash to rule them all (and use in templates or augeas or ...)
  $options = percona_hash_merge($my_configuration, $hashes)

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
  }

  file { $logdir :
    ensure => 'directory',
    mode   => $config_dir_mode,
    owner  => $daemon_user,
    group  => $logdir_group,
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

