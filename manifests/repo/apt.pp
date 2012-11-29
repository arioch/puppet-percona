# == Class: percona::repo::apt
#
class percona::repo::apt {

  apt::key { 'CD2EFD2A':
    ensure => present,
    notify => Exec['percona::repo::apt-get update'],
  }

  apt::sources_list { 'percona':
    ensure  => present,
    source  => false,
    content => template ("${module_name}/repo/sources.list.erb"),
    require => Apt::Key['CD2EFD2A'],
    notify  => Exec['percona::repo::apt-get update'],
  }

  exec { 'percona::repo::apt-get update':
    command     => 'apt-get update',
    path        => '/usr/bin',
    refreshonly => true,
  }


}
