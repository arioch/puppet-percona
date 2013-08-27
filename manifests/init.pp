# == Class: percona
#
# This class installs percona
#
# === Parameters:
#
# For a complete overview of the parameters you can use, take a look at
# percona::params. Parameters documented here can not be set globally.
#
# === Parameter Extras:
#
# For certain options, using '.' (dots) is not allowed. For this
# you can use $::percona::sanitized_servername. ('.' are replaced by '-')
#
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
#         priv     => ['Repl_slave_priv'],
#         host     => '$hostname',
#       }
#
#
#   THIS IS CURRENTLY NOT IMPLEMENTED!!!
#   #
#   #    ## This must be run on the slave nodes:
#   #    percona::slave { "whatever":
#   #      masterhost        => "hostip",
#   #      masterlog         => "masterlog",
#   #      masteruser        => "Replication user",
#   #      masterpassword    => "Repication password",
#   #      masterlogposition => "Masterlogposition",
#   #    }
#   #  }
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
  $config_skip      = $percona::params::config_skip,
  $config_replace   = $percona::params::config_replace,
  $config_include_dir = $::percona::params::config_include_dir,
  $server           = $percona::params::server,
  $service_enable   = $percona::params::service_enable,
  $service_ensure   = $percona::params::service_ensure,
  $service_name     = $percona::params::service_name,
  $service_restart  = $percona::params::service_restart,
  $daemon_group     = $percona::params::daemon_group,
  $daemon_user      = $percona::params::daemon_user,

  $tmpdir           = $percona::params::tmpdir,
  $logdir           = $percona::params::logdir,
  $logdir_group     = $percona::params::logdir_group,
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

  $mgmt_cnf         = $percona::params::mgmt_cnf,

  ## These options can NOT be defaulted in percona::params.
  # They are specific for this server instance.
  $configuration    = {},
  $servername       = $::fqdn,

  ## These settings are defaulted distro specific ##
  $template         = $percona::params::template,
  $config_dir       = $percona::params::config_dir,
  $config_file      = $percona::params::_config_file,

) inherits percona::params {

  $config_include_dir_default = $::percona::params::config_include_dir_default
  $config_includedir = $config_include_dir ? {
    undef   => $config_include_dir_default,
    default => $config_include_dir,
  }

  $sanitized_servername = regsubst($::percona::servername,'\.','-','G')


  ## Translate settings in params in a hash.
  $params = {
    'global'                      => {
      'mysqld/#-puppet-#servername'      => $::percona::servername,
      'mysqld/#-puppet-#logdir'          => $::percona::logdir,
      'mysqld/datadir'                   => $::percona::datadir,
      'mysqld/socket'                    => $::percona::socket,
      'mysqld/user'                      => $::percona::daemon_user,
      'mysqld/innodb_log_group_home_dir' => $::percona::datadir,
      'mysqld/log_bin'                   => "${::percona::datadir}/${sanitized_servername}-bin",
      'mysqld/relay_log'                 => "${::percona::datadir}/${sanitized_servername}-relay",
      'mysqld/slow_query_log_file'       => "${::percona::logdir}/${::percona::servername}-slow.log",
      'mysqld/symbolic-links'            => '0',

      'mysqld_safe/log-error'            => $::percona::errorlog,
      'mysqld_safe/pid-file'             => $::percona::pidfile,

      'xtrabackup/datadir'               => $::percona::datadir,
      'xtrabackup/target_dir'            => $::percona::targetdir,
    },
  }

  include percona::preinstall
  include percona::install
  include percona::config
  include percona::service

  Class['percona::preinstall'] ->
  Class['percona::install'] ->
  Class['percona::config'] ->
  Class['percona::service']

}

