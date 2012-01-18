# Class: percona::config
#
#
class percona::config {
  include percona::config::server
  include percona::config::client

  Class['percona::config::server'] ->
  Class['percona::config::client']
}
