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
  $admin_password   = $percona::params::admin_password,
  $client           = $percona::params::client,
  $config_content   = $percona::params::config_content,
  $config_dir       = $percona::params::config_dir,
  $config_dir_mode  = $percona::params::config_dir_mode,
  $config_file      = $percona::params::config_file,
  $config_file_mode = $percona::params::config_file_mode,
  $config_group     = $percona::params::config_group,
  $config_template  = $percona::params::config_template,
  $config_user      = $percona::params::config_user,
  $daemon_group     = $percona::params::daemon_group,
  $daemon_user      = $percona::params::daemon_user,
  $datadir          = $percona::params::datadir,
  $errorlog         = $percona::params::errorlog,
  $logdir           = $percona::params::logdir,
  $manage_repo      = $percona::params::manage_repo,
  $mysqlbufferpool  = $percona::params::mysqlbufferpool,
  $mysqlthreadcon   = $percona::params::mysqlthreadcon,
  $percona_version  = $percona::params::percona_version,
  $pidfile          = $percona::params::pidfile,
  $pkg_client       = $percona::params::pkg_client,
  $pkg_common       = $percona::params::pkg_common,
  $pkg_server       = $percona::params::pkg_server,
  $pkg_version      = $percona::params::pkg_version,
  $server           = $percona::params::server,
  $service_enable   = $percona::params::service_enable,
  $service_ensure   = $percona::params::service_ensure,
  $service_name     = $percona::params::service_name,
  $socket           = $percona::params::socket,
  $targetdir        = $percona::params::targetdir,
  $template         = $percona::params::template,
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

