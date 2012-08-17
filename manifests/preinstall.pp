# = Class: percona::preinstall
#
#
class percona::preinstall {

  require percona::params
  $client = $::percona::params::client
  $server = $::percona::params::server


  if $client {
  }

  if $server {
  }

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      apt::key { 'CD2EFD2A':
        ensure => present,
        notify => Exec['apt-get update'],
      }

      apt::sources_list { 'percona':
        ensure  => present,
        source  => false,
        content => template ('percona/sources.list.erb'),
        notify  => Exec['apt-get update'];
      }

      exec { 'apt-get update':
        command     => 'apt-get update',
        refreshonly => true;
      }
    }

    /(?i:redhat|centos)/: {
    }

    default: {
      fail 'Operating system not supported yet.'
    }
  }
}
