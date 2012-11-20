# == Definition: mysql::slave
#
# A basic helper used to create a slave, and a user.
#
# === Parameters:
#
#
# === Example usage:
#
#  percona::slave { "whatever":
#    masterhost     => 'hostip',
#    masterlog      => "masterlog",
#    masteruser     => "Replication user",
#  }
#
# === Todo:
#
# TODO: Document available parameters.
# TODO: Validate provided params.
#
#
define percona::slave (
  $ensure         = 'present',
  $masterhost     = hiera('master_all'),
  $masteruser     = hiera('master_user'),
  $masterpassword = hiera('masterpassword')
) {

  if ! $masterhost == 'none' {
    exec { 'replication-user':
      command => template('percona/commands/repli-user-command.erb'),
      unless  => template('percona/commands/repli-user-unless.erb'),
    }
    exec { 'slave-setup':
      command => template('percona/commands/slave-setup-command.erb'),
      unless  => template('percona/commands/slave-setup-unless.erb'),
    }
  }
}

