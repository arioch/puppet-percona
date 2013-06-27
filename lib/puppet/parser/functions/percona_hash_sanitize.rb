module Puppet::Parser::Functions

  newfunction(
    :percona_hash_sanitize,
    :type => :rvalue, :doc => <<-EODOC

    Sanitize a hash with keys.


  EODOC
  ) do |args|

    raise Puppet::ParseError, 'percona_hash_sanitize(): requires 1 parameter' unless args.size == 1
    hash = args.shift
    raise Puppet::ParseError, 'percona_hash_sanitize(): argument must be a Hash' unless hash.is_a?(Hash)

    default_value = { :ensure => 'present', :value => :undef, :section => 'mysqld' }
    clean = {}
    hash.map do |key,value|
      hash_value = default_value.dup
      if key =~ /^([^\/]+)\/([^\/]+)$/
        hash_value[:section] = $1
        hash_value[:key] = $2
      else
        hash_value[:key] = key
      end

      if ['present','absent'].include?(value)
        hash_value[:ensure] = value
      elsif value.is_a?(String) or value.is_a?(Integer) or value.is_a?(Array) or [true, false, :undef].include?(value)
        hash_value[:ensure] = 'present'
        hash_value[:value] = value
      elsif value.is_a?(Hash)
        hash_value.merge!(value)
      else
        raise Puppet::ParseError, "percona_hash_sanitize(): values should be strings, numbers, :undef, arrays or hashes, not #{value.inspect}"
      end
      clean["#{hash_value[:section]}/#{hash_value[:key]}"] = hash_value
    end
    clean

  end
end
