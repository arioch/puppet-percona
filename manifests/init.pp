# == Class: percona
#
# This class installs percona
#
# === Parameters:
#
# For a complete overview of the parameters you can use, take a look at
# percona::params. Parameters documented here can not be set globally.
#
# === Actions:
#  - Install PerconaDB
#
# === Requires:
#
# * Debian only:
#   - source: https://github.com/camptocamp/puppet-apt
#
# === Sample Usage:
#
# ==== This is the nodes.pp for the percona class
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
  $percona_version  = $percona::params::percona_version,
  $client           = $percona::params::client,
  $config_content   = $percona::params::config_content,
  $config_dir_mode  = $percona::params::config_dir_mode,
  $config_file_mode = $percona::params::config_file_mode,
  $config_user      = $percona::params::config_user,
  $config_group     = $percona::params::config_group,
  $config_template  = $percona::params::config_template,
  $server           = $percona::params::server,
  $service_enable   = $percona::params::service_enable,
  $service_ensure   = $percona::params::service_ensure,
  $service_name     = $percona::params::service_name,
  $daemon_group     = $percona::params::daemon_group,
  $daemon_user      = $percona::params::daemon_user,
  $tmpdir           = $percona::params::tmpdir,
  $logdir           = $percona::params::logdir,
  $socket           = $percona::params::socket,
  $datadir          = $percona::params::datadir,
  $targetdir        = $percona::params::targetdir,
  $errorlog         = $percona::params::errorlog,
  $pidfile          = $percona::params::pidfile,
  $manage_repo      = $percona::params::manage_repo,

  $pkg_client       = $percona::params::pkg_client,
  $pkg_common       = $percona::params::pkg_common,
  $pkg_server       = $percona::params::pkg_server,
  $pkg_compat       = $percona::params::pkg_compat,
  $pkg_version      = $percona::params::pkg_version,

  $mysqlbufferpool  = $percona::params::mysqlbufferpool,
  $mysqlthreadcon   = $percona::params::mysqlthreadcon,

  $template         = $percona::params::template,
  $config_dir       = $percona::params::config_dir,
  $config_file      = $percona::params::config_file,

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

