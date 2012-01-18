# Class percona::params
#
#
class percona::params {
  $service   = 'mysql'
  $user      = 'mysql'
  $group     = 'mysql'
  $logdir    = '/var/log/percona'
  $socket    = '/var/lib/mysql/mysql.sock'
  $datadir   = '/var/lib/mysql'
  $targetdir = '/data/backups/mysql/'
  $errorlog  = '/var/log/mysqld.log'
  $pidfile   = '/var/run/mysqld/mysqld.pid'

  case $::operatingsystem {
    'debian', 'ubuntu': {
      $pkg_version = $percona::percona_version

      $confdir    = '/etc/mysql'
      $config     = '/etc/mysql/my.cnf'
      $pkg_client = "percona-server-client-${pkg_version}"
      $pkg_server = "percona-server-server-${pkg_version}"
      $pkg_common = [
        'percona-toolkit',
        "percona-server-common-${pkg_version}"
      ]
    }

    'RedHat', 'CentOS': {
      case $percona::percona_version {
        '5.1':   { $pkg_version = '51' }
        '5.5':   { $pkg_version = '55' }
        default: { $pkg_version = '55' }
      }

      $config     = '/etc/my.cnf'
      $pkg_client = "Percona-Server-client-${pkg_version}"
      $pkg_server = "Percona-Server-server-${pkg_version}"
      $pkg_common = [
        'percona-toolkit',
        'Percona-Server-shared-compat',
        "Percona-Server-devel-${pkg_version}",
        "Percona-Server-shared-${pkg_version}",
      ]
    }

    default: {
      fail 'Operating system not supported yet.'
    }
  }
}
