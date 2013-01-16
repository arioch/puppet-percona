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
class percona::cluster {
  if ( $percona::cluster ) {
    $params = {
      'mysqld/server_id'                => $percona::cluster_index,
      'mysqld/wsrep_cluster_address'    => $percona::cluster_address,
      'mysqld/wsrep_node_name'          => $percona::cluster_node_name,
      'mysqld/wsrep_cluster_name'       => $percona::cluster_name,
      'mysqld/wsrep_slave_threads'      => $percona::cluster_slave_threads,
      'mysqld/wsrep_sst_method'         => $percona::cluster_sst_method,
      'mysqld/wsrep_provider'           => $percona::cluster_wsrep_provider,
      'mysqld/innodb_autoinc_lock_mode' => '2',
    }
  }
}
