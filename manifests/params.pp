# Class percona::params
#
#
class percona::params {
  $client            = true
  $config_content    = undef
  $config_dir_mode   = '0750'
  $config_file_mode  = '0640'
  $config_group      = 'root'
  $config_template   = undef
  $config_user       = 'root'
  $daemon_group      = 'mysql'
  $daemon_user       = 'mysql'
  $datadir           = '/var/lib/mysql'
  $errorlog          = '/var/log/mysqld.log'
  $logdir            = '/var/log/percona'
  $manage_repo       = false
  $mysqlbufferpool   = '150M'
  $mysqlthreadcon    = '1'
  $percona_version   = '5.1'
  $pidfile           = '/var/run/mysqld/mysqld.pid'
  $server            = false
  $service_enable    = true
  $service_ensure    = 'running'
  $service_name      = 'mysql'
  $socket            = '/var/lib/mysql/mysql.sock'
  $targetdir         = '/data/backups/mysql/'

  #$admin_password = hiera('mysql_password')
  $admin_password = 'default'

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      $pkg_version = $percona_version

      $config_dir  = '/etc/mysql'
      $config_file = '/etc/mysql/my.cnf'
      $template    = $config_template ? {
        undef   => 'percona/my.cnf.Debian.erb',
        default => $config_template,
      }
    }

    /(?i:redhat|centos)/: {
      $pkg_version = $percona_version ? {
        '5.1'   => '51',
        '5.5'   => '55',
        default => regsubst($percona_version, '\.', '', 'G'),
      }

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
