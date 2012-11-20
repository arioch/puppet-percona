# == Class percona::params
#
# === Parameters:
#
# $manage_repo::            This module can optionally install apt/yum repos.
#                           Disabled by default.
#
# === Provided parameters:
#
# $template::               Either the configured ($config_)template. Or our
#                           default template which is OS specific.
#
# $config_dir::             Location of the folder which holds the mysql my.cnf
#                           file for your operatingsystem.
#
# $config_file::            Location of the default mysql my.cnf config file
#                           for your operatingsystem.
#
# === Examples:
#
# ==== Setting global and default configuration options.
#
# === Todo:
#
# TODO: Document parameters
#
class percona::params (
  $percona_version   = '5.1',
  $client            = true,
  $config_content    = undef,
  $config_dir_mode   = '0750',
  $config_file_mode  = '0640',
  $config_user       = 'root',
  $config_group      = 'root',
  $config_template   = undef,
  $server            = false,
  $service_enable    = true,
  $service_ensure    = 'running',
  $service_name      = 'mysql',
  $daemon_group      = 'mysql',
  $daemon_user       = 'mysql',
  $logdir            = '/var/log/percona',
  $socket            = '/var/lib/mysql/mysql.sock',
  $datadir           = '/var/lib/mysql',
  $targetdir         = '/data/backups/mysql/',
  $errorlog          = '/var/log/mysqld.log',
  $pidfile           = '/var/run/mysqld/mysqld.pid',
  $manage_repo       = false,

  $pkg_client        = undef,
  $pkg_server        = undef,
  $pkg_common        = undef,
  $pkg_compat        = undef,
  $pkg_version       = undef,

  $mysqlbufferpool   = '150M',
  $mysqlthreadcon    = '1',

) {

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      $config_dir  = '/etc/mysql'
      $config_file = '/etc/mysql/my.cnf'
      $template    = $config_template ? {
        undef   => 'percona/my.cnf.Debian.erb',
        default => $config_template,
      }
    }

    /(?i:redhat|centos)/: {
      $config_file = '/etc/my.cnf'
      $template    = $config_template ? {
        undef   => 'percona/my.cnf.RedHat.erb',
        default => $config_template,
      }
    }

    default: {
      fail('Operating system not supported yet.')
    }
  }
}
