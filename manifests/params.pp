# Class percona::params
#
#
class percona::params {
  $percona_version = '5.1'
  $client          = true
  $server          = false
  $config_template = undef
  $config_content  = undef
  $service         = 'mysql'
  $user            = 'mysql'
  $group           = 'mysql'
  $logdir          = '/var/log/percona'
  $socket          = '/var/lib/mysql/mysql.sock'
  $datadir         = '/var/lib/mysql'
  $targetdir       = '/data/backups/mysql/'
  $errorlog        = '/var/log/mysqld.log'
  $pidfile         = '/var/run/mysqld/mysqld.pid'
  $mysqlthreadcon  = '1'
  $mysqlbufferpool = '150M'

  # TODO: Remove this from here, put admin password in a parameter
  #$admin_password = hiera('mysql_password')
  $admin_password = 'default' # quick fix for now, don't have hiera yet

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      $pkg_version = $percona_version

      $confdir    = '/etc/mysql'
      $config     = '/etc/mysql/my.cnf'
      $template = $config_template ? {
        undef   => 'percona/my.cnf.Debian.erb',
        default => $config_template,
      }
      $pkg_client = "percona-server-client-${pkg_version}"
      $pkg_server = "percona-server-server-${pkg_version}"
      $pkg_common = [
        'percona-toolkit',
        "percona-server-common-${pkg_version}"
      ]
    }

    /(?i:redhat|centos)/: {
      $pkg_version = $percona_version ? {
        '5.1'      => '51',
        '5.5'      => '55',
        default    => regsubst($percona_version, '\.', '', 'G'),
      }

      $config     = '/etc/my.cnf'
      $template = $config_template ? {
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
