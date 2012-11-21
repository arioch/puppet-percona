# Puppet Percona

## PuppetDoc

Parsed PuppetDoc can be found [here](http://arioch.github.com/puppet-percona/).

## Requirements

### Debian/Ubuntu
* Camptocamp [apt module]

## Basic usage

### Client only

```puppet
  class { 'apt': }
  class { 'percona': }

  Class['apt'] ->
  Class['percona']
```

### Client and server

```puppet
    class { 'apt': }
    class { 'percona': server => true, }

    Class['apt'] ->
    Class['percona']
```

### Configuration

#### Using percona::conf

Before being able to use percona::conf, you should set the config_include_dir
parameter. You can do this in percona::params or when calling percona.

For debian users, the config_include_dir has been defaulted to /etc/mysql/conf.d/

```puppet

    # This will create a file in the config_folder for each entry.
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

```

### Databases and permissions.

```puppet

    percona::database { 'dbfoo':
      ensure => present;
    }

    percona::rights {'userbar on dbfoo':
      priv => 'select_priv',
      host => 'localhost',
      database => '*'
      password => 'default',
    }

    # You can ommit the user, host and database parameter if you use this format:
    percona::rights {'user@localhost/dbname':
      priv => 'all'
    }

```

### Unit testing

Unit testing is done using [rspec-puppet]:

    # bundle && bundle exec rspec

[apt module]: https://github.com/camptocamp/puppet-apt
[rspec-puppet]: https://github.com/rodjek/rspec-puppet

