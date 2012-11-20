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



EODOC
  ) do |args|

    # Helper function. If a more global hash has a value
    # that we do not have, add it. By working like this,
    # the first arguments override hashes after them.
    def recursive_merge(me, other)
      other.each do |k,v|
        if ! me.include?(k)
          me[k] = v
        end
      end
    end

    args = [args] unless args.is_a?(Array)
    args.flatten!

    # This are default parameters for each entry in our hash.
    keyset_default = { :ensure => 'present', :value => :undef, :section => 'mysqld'}

    # Sanitize ALL the hashes! Add/merge with our keyset_default.
    args.each do |hash|
      # Yeah, we only handle hashes well.
      raise(Puppet::ParseError, 'percona_hash_merge(): Arguments should be hashes') unless hash.is_a?(Hash)

      # Loop over the key-value pairs.
      hash.map do |key,value|
        if key =~ /^([^\/]+)\/([^\/]+)$/
          # If the key is something like section/value, parse section and key accordingly.
          hashkey = {:section => $1, :key => $2 }
        else
          # Forward the key.
          hashkey = {:key => key }
        end

        # key => 'present' or 'absent' are special values which we handle here.
        # this is a shortcut for parameters that take no arguments but should just be present.
        if ['present', 'absent'].include?(value)
          hashkey = hashkey.merge({ :value => :undef, :ensure => value,})

        # Handle Strings, Integers, Booleans and undefined.
        elsif value.is_a?(String) or value.is_a?(Integer) or [true, false, :undef].include?(value)
          hashkey = hashkey.merge({ :value => value, :ensure => 'present', })

        # If its a hash, we presume it already has proper parameters defined.
        elsif value.is_a?(Hash)
          hashkey = hashkey.merge(value)

        # Anything else is not allowed.
        else
          raise(Puppet::ParseError, 'percona_hash_merge(): Values should be strings, numbers, :undef or hashes.')
        end

        hash[key] = keyset_default.merge(hashkey)
      end
    end

    # The first hash in the array (first argument) is the most correct.
    result_hash = args.shift

    ## Merge them here ;)
    args.each do |hash|
      recursive_merge(result_hash,hash)
    end

    result_hash

  end
end
