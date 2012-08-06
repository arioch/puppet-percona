# = Class: percona
#
# This class installs percona
#
# == Parameters:
#
# == Actions:
#  - Install PerconaDB
#  - Install PerconaXtraDB
#
# == Requires:
#
# == Sample Usage:
#
# === This is the nodes.pp for the percona class
#
#     node hostname{
#
#       # This is generic mysql stuff
#       $mysqlbufferpool = '100M'
#       $mysqlserverid   = "100"
#       $mysqlthreadcon  = "1"
#
#
#       class { 'percona::params':
#         server          => true,
#         percona_version => '5.1',
#       }
#       include percona
#
#
#       ## Creation of databases
#       percona::database{'<databasename>':
#         ensure   => present
#       }
#
#       ## This must be run on the master
#       percona::rights {'Set rights for replication':
#         user     => 'repl',
#         password => 'repl',
#         database => ['%'],
#         priv     => ['slav_priv'],
#         host     => '$hostname',
#       }
#
#       ## This must be run on the slave nodes:
#       percona::slave { "whatever":
#         masterhost => "hostip",
#         masterlog  => "masterlog",
#         masteruser => "Replication user",
#         masterpassword => "Repication password",
#         masterlogposition => "Masterlogposition",
#       }
#     }
#
#
class percona {

  include percona::preinstall
  include percona::install
  include percona::config
  include percona::service

  Class['percona::preinstall'] ->
  Class['percona::install'] ->
  Class['percona::config'] ->
  Class['percona::service']


}

