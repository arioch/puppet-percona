define percona::user (
  $password,
  $database,
  $ensure = present,
  $host   = 'localhost'
) {
  case $ensure {
    'present': {
      exec { "MySQL: create user ${name}":
        command => "mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"GRANT ALL PRIVILEGES ON ${database}.* TO '${name}'@'${host}' IDENTIFIED BY '${password}' WITH GRANT OPTION;\";",
        require => Class['percona::service'],
        unless  => "mysql --user=${name} --password=${password} --database=${database} --host=${host}",
      }
    }

    'absent': {
      exec { "MySQL: create user ${name}":
        command => "mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"DROP USER ${name};\";",
        require => Class['percona::service'],
        onlyif  => "mysql --user=${name} --password=${password}",
      }
    }

    default: {
    }
  }
}
