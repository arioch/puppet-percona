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
  $admin_password = 'default' # quick fix for now, don't have hiera yet

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      $pkg_version = $percona_version

      $config_dir  = '/etc/mysql'
      $config_file = '/etc/mysql/my.cnf'
      $template    = $config_template ? {
        undef   => 'percona/my.cnf.Debian.erb',
        default => $config_template,
      }
      $pkg_client  = "percona-server-client-${pkg_version}"
      $pkg_server  = "percona-server-server-${pkg_version}"
      $pkg_common  = [
        'percona-toolkit',
        "percona-server-common-${pkg_version}"
      ]
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

      $pkg_client = "Percona-Server-client-${pkg_version}"
      $pkg_server = "Percona-Server-server-${pkg_version}"
      $pkg_common = [
        "Percona-Server-shared-${pkg_version}",
        'percona-toolkit'
      ]

    }

    default: {
      fail('Operating system not supported yet.')
    }
  }
}
