# = Class: percona::preinstall
#
#
class percona::preinstall {
  if $::percona::manage_repo {
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
        yumrepo { 'percona':
          descr    => 'CentOS $releasever - Percona',
          baseurl  => 'http://repo.percona.com/centos/$releasever/os/$basearch/',
          gpgkey   => 'http://www.percona.com/downloads/percona-release/RPM-GPG-KEY-percona',
          enabled  => 1,
          gpgcheck => 1;
        }

      }

      default: {
        fail "Operating system ${::operatingsystem} is not supported yet."
      }
    }
  }
}
