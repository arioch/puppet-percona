# = Class: percona::config::server
#
#
class percona::config::server {
  $server       = $::percona::server
  $config_user  = $::percona::config_user
  $config_group = $::percona::config_group
  $confdir      = $::percona::confdir
  $service_name = $::percona::service_name

  if $server {
    File {
      owner   => $config_user,
      group   => $config_group,
      require => Class['percona::install'],
      notify  => Service[$service_name],
    }

    if $confdir {
      file { $confdir:
        ensure => 'directory';
      }
    }

    file { $logdir :
      ensure => 'directory',
      owner  => 'mysql',
      group  => 'mysql',
      mode   => '0750',
    }

    ## Config file ##
    file { $config:
      ensure => 'present',
    }

    # Use provided content or default/overriden template.
    if $config_content {
      File[$config] {
        content => $config_content,
      }
    }
    else {
      File[$config] {
        content => template($template),
      }
    }
  }
}

