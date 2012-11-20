# = Class: percona::preinstall
#
#
class percona::preinstall {

  if $::percona::manage_repo {
    case $::operatingsystem {
      /(?i:debian|ubuntu)/: {
        include percona::repo::apt
      }
      /(?i:redhat|centos)/: {
        include percona::repo::yum
      }
      default: {
        fail('Manage repos is enabled but this operating system not supported yet.')
      }
    }
  }
}
