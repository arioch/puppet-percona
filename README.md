# Puppet Percona

Install a percona (mysql) server and manage users/rights/databases.

## Requirements

### Debian/Ubuntu
* [Camptocamp apt module]
or 
* [Puppetlabs apt module]

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


#### Using percona hashes

To make sure we allow maximal flexibility while using this module, you can now
specify my.cnf options using a hash. You can do so in 2 different places:

You can specify the default_configuration parameter on percona::params and/or
you can specify the configuration parameter on percona.
Why can you use 2 different places?

You can use percona::params to set options globally over your complete
infrastructure and all hosts connected to it. You can do so by defining it
outside the scope of your node (a defaults.pp or a class that is included on
every node, ...). Then, you could overwrite these global options for each
server specifically when you define the percona resource.

Not enough possibilities? Store your configuration in hiera and directly
use the hash returned by the hiera function and pass it through. This allows
you to specify the configuration of your server on pretty much any level
you want.

How do these hashes look like? The (nested) hash you pass to percona::params
should look like this:

```puppet

    $hash = {
      '5.1'    => {
        'mysqld/option' => '5.1 specific value',
      },
      '5.5'    => {
        'mysqld/option'  => '5.5 specific value',
        'mysqld/option2' => 'only exists in 5.5'
      },
      'global' => {
        'mysqld/global'     => 'global option that works for any percona version',
        'xtrabackup/global' => 'global option in the xtrabackup section'
      },
    }
    class {'percona::params':
      default_configuration => $hash,
    }

```

For options that get passed to percona using the configuration parameter, you
do not need to nest the parameters since you will have picked the percona
version to use at this point.

```puppet

  $configuration = {
    'mysqld/option' => 'something',
    'mysqld/option2' => { 'ensure' => 'absent' },
  }
  class {'percona':
    percona_version => '5.5',
    configuration   => $configuration,
  }


```
----

For more information on the structures you can use, please see the docs of the
percona_hash_merge() function.

An example hiera.yaml file:

(Note: we need to put 5.5 and 5.1 between quotes or puppet they are turned into
numbers which does not play well with the module.

```yaml

percona_config_global:
  "5.5":
    character-set-server: utf8

  "5.1":
    default-character-set: utf8

  global:
    thread_concurrency: %{processorcount}
    default-storage-engine: 'InnoDB'

```

and in your manifests

```puppet

  class {'percona::params':
    default_configuration => hiera('percona_config_global', undef),
  }

  include percona

```

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
      priv     => 'select_priv',
      host     => 'localhost',
      database => '*',
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

[camptocamp apt module]: https://github.com/camptocamp/puppet-apt
[Puppetlabs apt module]: https://github.com/puppetlabs/puppetlabs-apt
[rspec-puppet]: https://github.com/rodjek/rspec-puppet

