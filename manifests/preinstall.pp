# Class: percona::preinstall
#
#
class percona::preinstall {
  if $percona::client {
  }

  if $percona::server {
  }

  case $::operatingsystem {
    'debian', 'Debian', 'ubuntu', 'Ubuntu': {
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

    'RedHat', 'redhat', 'CentOS', 'centos': {
      package { 'percona-release':
        ensure   => present,
        provider => 'rpm',
        source   => "http://www.percona.com/redir/downloads/percona-release/percona-release-0.0-1.${::hardwaremodel}.rpm";
      }
    }

    default: {
      fail 'Operating system not supported yet.'
    }
  }
}
