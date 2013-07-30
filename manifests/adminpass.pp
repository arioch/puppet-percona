# == Definition: percona::adminpass
#
# Sets a password for an (admin) user who does not have one yet.
# This class can be used to set the root password upon installation.
#
# Use this in combination with the mgmt_cnf type and/or parameter.
#
# The class will automaticly set the correct dependencies between
# the Mgmt_cnf types, databases and rights.
#
# === Parameters:
#
# $password::       Plaintext password to set.
#
# $user::           Username of the user to adjust.
#                   Defaults to the name of the resource.
#
# $host::           Hostname to connect to. Defaults to 'localhost'.
#
# $logoutput::      Override the logouput parameter of the exec statement.
#                   Defaults to false since we don't want the password to
#                   show up in our logs. Use with care (and debugging only).
#
#
# === Example Usage:
#
#     $user = 'root'
#     $pass = 'foobar'
#     $mgmt_cnf = '/etc/.puppet.cnf'
#
#     percona::adminpass{ $user:
#       password  => $pass,
#     }
#     percona::mgmt_cnf {$mgmt_cnf:
#       password => $pass,
#       user     => $user,
#     }
#     class {'percona::params':
#       mgmt_cnf => $mgmt_cnf,
#     }
#
#
define percona::adminpass (
  $password,
  $user      = $name,
  $host      = 'localhost',
  $logoutput = false
) {

  exec {"percona-adminpass-${name}":
    onlyif    => [
      'test -f /usr/bin/mysqladmin',
      "mysqladmin --no-defaults -u${user} -h${host}  status",
    ],
    path      => ['/usr/bin','/bin',],
    command   => "mysqladmin -h ${host} -u${user} password ${password}",
    logoutput => $logoutput,
  }

  # Ensure that we have the proper ordering.
  Service['mysql'] ->             # start mysql
  Percona::Adminpass<| |> ->      # set the password if needed
  Percona::Mgmt_cnf<| |>          # create any mgmt_cnf files we have defined.

}
