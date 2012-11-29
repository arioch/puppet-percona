# = Class: percona::preinstall
#
#
class percona::preinstall {

  if $::percona::manage_repo {
    case $::operatingsystem {
      /(?i:debian|ubuntu)/: {
        class {'percona::repo::apt':
          before => Class['percona::install'],
        }
      }
      /(?i:redhat|centos)/: {
        class {'percona::repo::yum':
          before => Class['percona::install'],
        }
      }
      default: {
        fail('Manage repos is enabled but this operating system not supported yet.')
      }
    }
  }
}
