# == Definition: percona::mgmt_cnf
#
# Creates a simple my.cnf file for authentication purposes.
# The file will get '0400' permissions (readonly for the user).
# You can override this, but it is NOT recommended since your password
# will be in plain text in this file.
#
# We support the mysql and mysqladmin command in this config file.
#
# === Parameters:
#
# $name::     Path to the my.cnf file to create.
#
# $password:: The mysql password (plaintext).
#
# $user::     The mysql user. Defaults to 'root'.
#
# $owner::    Owner of the created file. Defaults to 'root'.
#
# $group::    Group that owns the created file. Defaults to 'root'.
#
# $mode::     Override the mode of the created file. Defaults to '0400'.
#
define percona::mgmt_cnf (
  $password,
  $user      = 'root',
  $owner     = 'root',
  $group     = 'root',
  $mode      = '0400',
  $path      = $name,
) {

  file {$name:
    path    => $path,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => template("${module_name}/mgmt_cnf.erb"),
  }

  Percona::Mgmt_cnf<| |> -> Percona::Database<| |> -> Percona::Rights<| |>

}
