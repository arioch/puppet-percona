# == Class percona::params
#
# === Parameters:
#
# === Provided parameters:
#
# === Examples:
#
# ==== Setting global and default configuration options.
#
# === Todo:
#
# TODO: Document parameters
#
class percona::cluster (
  $cluster           = false,
  $cluster_index     = undef,
  $cluster_address   = 'gcomm://',
  $cluster_node_name = $fqdn,
  $cluster_name      = undef,
  $cluster_slave_threads = 2,
  $cluster_sst_method = 'xtrabackup',
) {

  $cluster_wsrep_provider = $::hardwareisa ? {
    'x86_64' => '/usr/lib64/libgalera_smm.so',
    default  => '/usr/lib/libgalera_smm.so',
  }

  if ( $percona::cluster ) {
    $params = {
      'mysqld/server_id'             => $percona::cluster_index,
      'mysqld/wsrep_cluster_address' => $percona::cluster_address,
      'mysqld/wsrep_node_name'       => $percona::cluster_node_name,
      'mysqld/wsrep_cluster_name'    => $percona::cluster_name,
      'mysqld/wsrep_slave_threads'   => $percona::cluster_slave_threads,
      'mysqld/wsrep_sst_method'      => $percona::cluster_sst_method,
      'mysqld/wsrep_provider'        => $percona::cluster_wsrep_lib,
    }
  }
}
