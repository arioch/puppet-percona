# Puppet Percona

## PuppetDoc

Parsed PuppetDoc can be found [here](http://arioch.github.com/puppet-percona/).

## Requirements

* Camptocamp [apt module]

## Basic usage

### Client only
    class { 'apt': }
    class { 'percona': }

    Class['apt'] ->
    Class['percona']

### Client and server
    class { 'apt': }
    class { 'percona': server => true; }

    Class['apt'] ->
    Class['percona']

### Configuration
    percona::conf {
      'innodb_file_per_table': content => "[mysqld]\ninnodb_file_per_table";
      'query_cache_size':      content => "[mysqld]\nquery_cache_size = 32M";
      'table_open_cache':      content => "[mysqld]\ntable_open_cache = 768";

      'foo':
        ensure  => present,
        content => template ("percona/custom1.cnf.erb");
      'bar':
        ensure  => absent,
        content => template ("percona/custom2.cnf.erb");
    }

    percona::database { 'dbfoo':
      ensure => present;
    }

    percona::user { 'userfoo':
      ensure   => present,
      password => 'default',
      database => 'dbfoo';
    }

    percona::user { 'userbar':
      ensure   => present,
      password => 'default',
      database => 'dbfoo';
    }

### Unit testing

Unit testing is done using [rspec-puppet]:

    # bundle && bundle exec rspec

[apt module]: https://github.com/camptocamp/puppet-apt
[rspec-puppet]: https://github.com/rodjek/rspec-puppet

