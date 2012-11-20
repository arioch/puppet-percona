# == Definition: percona::augeas
#
# Set mysql configuration parameters
#
# === Parameters:
#
# $ensure::   defaults to present.
#
# $value::    The value to be set, defaults to the empty string.
#
# $key::      Optionally, set the key.
#             Defaults to the name (without the section/ part).
#
# $section::  Optionally, set the section to configure.
#             Defaults to the first part in the name or mysqld.
#
# === Example usage:

#   percona::augeas {'mysqld/pid-file':
#     ensure  => present,
#     value   => '/var/run/mysqld/mysqld.pid',
#   }
#
# === Note:
#
# By default, the configuration file in this module is templated.
# So changes made here will be overwritten!
# Change the config style to initial_only or combined.
#
define percona::augeas (
  $ensure  = 'present',
  $value   = '',
  $section = undef,
  $key     = undef,
) {

  ## If we are calling this directly without using the percona module...
  if defined(Class['percona']) {

    Augeas {
      before    => Service[$::percona::service_name],
    }

    if $::percona::service_restart {
      Augeas {
        notify => Service[$::percona::service_name],
      }
    }

    ## We asked the module to skip configuration so we can not require the file.
    if $::percona::config_skip != false {
      Augeas {
        require   => File[$::percona::config_file],
      }
    }
  }

  case $name {
    /(.*)\/(.*)/: {
      $default_key = $2
      $default_section = $1
    }
    default: {
      $default_key = $name
      $default_section = 'mysqld'
    }
  }

  $real_key = $key ? {
    undef   => $default_key,
    default => $key,
  }

  $real_section = $section ? {
    undef   => $default_section,
    default => $section,

  }

  case $ensure {
    present: {
      $changes = "set target[.='${real_section}']/${real_key} ${value}"
    }

    absent: {
      $changes = "rm target[.='${real_section}']/${real_key}"
    }

    default: { err ( "unknown ensure value ${ensure}" ) }
  }

  augeas { "my.cnf/${real_section}/${name}":
    incl      => $::percona::config_file,
    lens      => 'MySQL.lns',
    changes   => [
      "set target[.='${real_section}'] ${real_section}",
      $changes,
      'rm target[count(*)=0]',
    ],
  }
}
