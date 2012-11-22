# == Definition: mysql::rights
#
# A basic helper used to create a user and
# grant him some privileges on a database.
#
# If you are using restricted admin accounts (with a password),
# you will need to use the mgmt_cnf parameter.
#
# === Parameters:
#
# $ensure::   defaults to present
#
# $database:: the target database
#
# $user::     the target user
#
# $password:: user's password
#
# $host::     target host, default to "localhost"
#
# $priv::     target privileges, defaults to "all"
#             (values are the fieldnames from mysql.db table).
#
# === Example usage:
#  mysql::rights { 'example case':
#    user     => 'foo',
#    password => 'bar',
#    database => 'mydata',
#    priv     => ['select_priv', 'update_priv'],
# }
#
define percona::rights (
  $priv     = 'all',
  $password = undef,
  $database = undef,
  $host     = 'localhost',
  $user     = undef,
  $hash     = undef,
  $ensure   = 'present',
  $mgmt_cnf = undef
) {

  $mycnf = $mgmt_cnf ? {
    undef   => $::percona::mgmt_cnf,
    default => $mgmt_cnf,
  }

  ## Determine the default user/host to use derived from the resource name.
  case $name {
    /^(\w+)@([^ ]+)\/(\w+)$/: {
      $default_user = $1
      $default_host = $2
      $default_database = $3
    }
    /^(\w+)@([^ ]+)$/: {
      $default_user = $1
      $default_host = $2
      $default_database = undef
    }
    default: {
      $default_user = undef
      $default_host = undef
      $default_database = undef
    }
  }

  if $hash == undef and $password == undef {
    fail('You must either provide the password hash to use or a plaintext password')
  }
  if $user == undef and $default_user == undef {
    fail('You must define the user parameter or use proper formatting in the name: "user@host/database"')
  }
  if $host == undef and $default_host == undef {
    fail('You must define the host parameter or use proper formatting in the name: "user@host/database"')
  }


  $_user = $user ? {
    undef   => $default_user,
    default => $user,
  }

  ## Host param
  $_host = $host ? {
    undef   => $default_host,
    default => $host,
  }

  ## Database param
  $_database = $database ? {
    undef   => $default_database,
    default => $database,
  }

  $grant_name = $_database ? {
    undef   => "${_user}@${_host}",
    default => "${_user}@${_host}/${_database}",
  }

  if ! defined(Mysql_user["${_user}@${_host}"]) {
    $pwhash = $hash ? {
      undef   => mysql_password($password),
      default => $hash,
    }

    mysql_user { "${_user}@${_host}":
      ensure        => 'present',
      password_hash => $pwhash,
      mgmt_cnf      => $mycnf,
      require       => [
        Service[$::percona::service_name],
      ],
    }
  }

  mysql_grant { $grant_name:
    privileges => $priv,
    mgmt_cnf   => $mycnf,
    require    => [
      Service[$::percona::service_name],
      Mysql_user["${_user}@${_host}"],
    ]
  }

}
