# slave.pp
#
#
# == Definition: mysql::slave
#
# A basic helper used to create a slave, and a user.
#
# Example usage:
#  percona::slave { "whatever":
#    masterhost     => 'hostip',
#    masterlog      => "masterlog",
#    masteruser     => "Replication user",
#}
#
# Available parameters:
#
define percona::slave (
  $ensure         = 'present',
  $masterhost     = hiera('master_all'),
  $masteruser     = hiera('master_user'),
  $masterpassword = hiera('masterpassword')
) {

  if $masterhost == 'none' {

  }
  else{
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
