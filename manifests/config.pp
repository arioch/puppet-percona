# Class: percona::config
#
#
class percona::config {

  $server        = $::percona::server

  if $server {
    include percona::config::server
  }

}
