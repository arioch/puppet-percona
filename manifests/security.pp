# == Class: percona::security
#
# === Todo:
#
# TODO: Document class.
#
# Some installations have some default users which are not required.
# We remove them here. You can subclass this class to overwrite this behavior.
class percona::security (
  $mgmt_cnf = undef
) {
  $mycnf = $mgmt_cnf ? {
    undef   => $::percona::mgmt_cnf,
    default => $mgmt_cnf,
  }

  $users = ["root@${::fqdn}", 'root@127.0.0.1', 'root@::1', "@${::fqdn}", '@localhost', '@%']

  mysql_user { $users:
    ensure   => 'absent',
    mgmt_cnf => $mycnf,
    require  => [Service[$::percona::service_name], Percona::Mgmt_cnf[$mycnf]],
  }

  if ($::fqdn != $::hostname) {
  mysql_user { ["root@${::hostname}", "@${::hostname}"]:
      ensure   => 'absent',
      mgmt_cnf => $mycnf,
      require  => [Service[$::percona::service_name], Percona::Mgmt_cnf[$mycnf]],
    }
  }

  mysql_database { 'test':
    ensure   => 'absent',
    mgmt_cnf => $mycnf,
    require  => [Service[$::percona::service_name], Percona::Mgmt_cnf[$mycnf]],
  }
}
