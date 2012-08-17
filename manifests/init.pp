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
#     source: https://github.com/camptocamp/puppet-apt
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
#       class {
#         'apt':;   # debian only
#         'percona':
#           server          => true,
#           percona_version => '5.1',
#       }
#
#
#       ## Creation of databases
#       percona::database{'<databasename>':
#         ensure => present
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
#         masterhost        => "hostip",
#         masterlog         => "masterlog",
#         masteruser        => "Replication user",
#         masterpassword    => "Repication password",
#         masterlogposition => "Masterlogposition",
#       }
#     }
#
class percona (
  $percona_version = $percona::params::percona_version,
  $client          = $percona::params::client,
  $server          = $percona::params::server,
  $config_template = $percona::params::config_template,
  $config_content  = $percona::params::config_content,
  $service_name    = $percona::params::service_name,
  $service_enable  = $percona::params::service_enable,
  $service_ensure  = $percona::params::service_ensure,
  $config_user     = $percona::params::config_user,
  $config_group    = $percona::params::config_group,
  $daemon_user     = $percona::params::daemon_user,
  $daemon_group    = $percona::params::daemon_group,
  $logdir          = $percona::params::logdir,
  $socket          = $percona::params::socket,
  $datadir         = $percona::params::datadir,
  $targetdir       = $percona::params::targetdir,
  $errorlog        = $percona::params::errorlog,
  $pidfile         = $percona::params::pidfile,
  $mysqlthreadcon  = $percona::params::mysqlthreadcon,
  $mysqlbufferpool = $percona::params::mysqlbufferpool,
  $admin_password  = $percona::params::admin_password,
  $pkg_version     = $percona::params::pkg_version,
  $confdir         = $percona::params::confdir,
  $config          = $percona::params::config,
  $template        = $percona::params::template,
  $pkg_client      = $percona::params::pkg_client,
  $pkg_server      = $percona::params::pkg_server,
  $pkg_common      = $percona::params::pkg_common,
) inherits percona::params {

  include percona::preinstall
  include percona::install
  include percona::config
  include percona::service

  Class['percona::preinstall'] ->
  Class['percona::install'] ->
  Class['percona::config'] ->
  Class['percona::service']

}

