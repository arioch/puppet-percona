define percona::database ( $ensure, $dump = undef ) {
  case $ensure {
    present: {
      exec { "MySQL: create $name db":
        command => "mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"CREATE DATABASE ${name}\";",
        unless  => "mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"SHOW DATABASES;\" | grep -x '${name}'",
        require => Class['percona::service'],
      }
    }

    importdb: {
      exec { "MySQL: import db":
        command => "mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"CREATE DATABASE ${name}\";
              mysql --defaults-file=/etc/mysql/debian.cnf ${name} < ${dump}",
        require => Class['percona::service'],
      }
    }

    absent: {
      exec { "MySQL: drop $name db":
        command => "mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"DROP DATABASE ${name}\";",
        onlyif  => "mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"SHOW DATABASES;\" | grep -x '${name}'",
        require => Class['percona::service'],
      }
    }

    default: {
      fail "Invalid 'ensure' value '$ensure' for mysql::database"
    }
  }
}
