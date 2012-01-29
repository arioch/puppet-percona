# Class: percona::install
#
#
class percona::install {
  Package {
    require => [
      Class['percona::params'],
      Class['percona::preinstall'],
    ],
  }

  package {
    $percona::params::pkg_common:
      ensure => present;
  }

  if $percona::client {
    package {
      $percona::params::pkg_client:
        ensure  => present,
        require => Package[$percona::params::pkg_common];
    }
  }

  if $percona::server {
    package {
      $percona::params::pkg_server:
        ensure  => present,
        require => Package[$percona::params::pkg_client];
    }
  }
}
