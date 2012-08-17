# = Definition: mysql::rights
#
#A basic helper used to create a user and
#grant him some privileges on a database.
#
# == Parameters:
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
# == Example usage:
#  mysql::rights { 'example case':
#    user     => 'foo',
#    password => 'bar',
#    database => 'mydata',
#    priv     => ['select_priv', 'update_priv'],
# }
#
define percona::rights (
  $database,
  $user,
  $password,
  $host,
  $priv,
  $ensure = 'present'
) {

  $config_file = $::percona::config_file


  if $::mysql_uptime != 0 {
    if ! defined(Mysql_user["${user}@${host}"]) {
      mysql_user { "${user}@${host}":
        password_hash => mysql_password($password),
        require       => File[$config_file],
      }
    }
    mysql_grant { "${user}@${host}/${database}":
      privileges => $priv,
      require    => File[$config_file],
    }
  }

}
