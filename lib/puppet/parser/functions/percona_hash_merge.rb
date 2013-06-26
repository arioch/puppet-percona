module Puppet::Parser::Functions


  newfunction(:percona_hash_merge,
    :type => :rvalue, :doc => <<-EODOC
  == Function: percona_hash_merge

  Merges hashes. If multiple hashes are provided, the ones
  that are in the front of the argument list override values from
  hashes that come later in the array.

  You can also use this function on a single hash. In this case, it is
  obviously not merged but we still convert the key-value pairs to
  the correct format for augeas/print_percona_hash.

  === Arguments: hashes with 'key => value' pairs...

  If the value is a string, present and absent are special values
  which will result in:

    {:value => :undef, :ensure => 'present',:section => 'mysqld',}

  or

    {:value => :undef, :ensure => 'absent, :section => 'mysqld', :key => 'value' }

  To explicitly use the value present (or absent), use

    {:value => 'present'} or {:value => 'absent' }


  === Example:

    $my_settings = {
      'mysqld/tmpdir'                        => '/var/tmp',
      'mysqld/log-queries-not-using-indexes' => 'absent',
    }

    $global_settings = {
      'mysqld/tmpdir'           => '/tmp',
      'mysqld/max_binlog_size'  => '100M',
    }

    $merged = percona_hash_merge($my_settings, $global_settings)

  This will result in an combined hash looking like this:

    {
      'mysqld/log-queries-not-using-indexes' => {
        :value   => :undef,
        :section => 'mysqld',
        :key     => 'log-queries-not-using-indexes',
        :ensure  => 'absent',
      },
      'mysqld/max_binlog_size' => {
        :value   => '100M',
        :section => 'mysqld',
        :key     => 'max_binlog_size',
        :ensure  => 'present',
       },
      'mysqld/tmpdir' => {
        :value   => '/var/tmp',
        :section => 'mysqld',
        :key     => 'tmpdir',
        :ensure  => 'present',
      },
    }

  As you can see, this is perfect to use in combination in your template with
  the print_percona_hash function(). It also is ready to use in combination with
  the create_resources function. I would almost suggest

    create_resources('percona::augeas', $merged)

  Note: When specifying an array as a value, you could think that the array
        would also be merged, this is NOT the case. An array behaves like a
        string would, the value gets overridden completely.

EODOC
  ) do |args|

    args = [args] unless args.is_a?(Array)
    args.flatten!

    sanitized = []
    # Sanitize ALL the hashes! Add/merge with our keyset_default.
    args.each do |hash|
      # Yeah, we only handle hashes well.
      raise(Puppet::ParseError, 'percona_hash_merge(): Arguments should be hashes') unless hash.is_a?(Hash)
      sanitized << function_percona_hash_sanitize([hash])
    end

    # The first hash in the array (first argument) is the most correct.
    result_hash = sanitized.shift

    ## Merge them here ;)
    sanitized.each do |hash|
      hash.each do |k,v|
        if ! result_hash.include?(k)
          result_hash[k] = v
        end
      end
    end

    result_hash

  end
end
