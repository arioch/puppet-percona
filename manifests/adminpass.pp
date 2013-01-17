# Sets a password for a user who does not have one yet.
class percona::adminpass (
  $password,
  $user = 'root',
  $host = 'localhost',
) {

  exec {"percona-adminpass-${name}":
    onlyif => [
      'test -f /usr/bin/mysqladmin',
      "mysqladmin -u${user} -h${host} status",
    ],
    path    => ['/usr/bin','/bin',],
    command => "mysqladmin -h ${host} -u${user} password ${password}",
  }

  # Ensure that we have the proper ordering.
  Service['mysql'] ->             # start mysql
  Class['percona::adminpass'] ->  # set the password if needed
  Percona::Mgmt_cnf<| |> ->       # create any mgmt_cnf files we have defined.
  Percona::Database<| |> ->       # create databases
  Percona::Rights<| |>            # and setup users/rights.

}
