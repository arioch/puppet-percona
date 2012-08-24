# Define percona::user
#
#
define percona::user (
  $password,
  $database,
  $ensure = present,
  $host   = 'localhost'
) {

  #
  # WARNING:
  # Needs refactoring in order to work on any non-Debian distro.
  # Better yet user.pp should be split to a separate module which can
  # be used by other MySQL distro's as well.
  #

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
