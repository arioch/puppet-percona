
module Puppet::Parser::Functions

  newfunction(:percona_hash_print_section,
              :type => :rvalue, :doc => <<-EODOC

  Prints (returns a string) a single section from a hash created by percona_hash
  merge to a my.cnf style. Options that have :ensure absent are not printed.

  This does not include the section header [section]. Use percona_hash_print() if you want that.

  The first argument should be the hash to work on to print as created by percona_hash_merge().

  The second argument should be the section to print..

  EODOC

  ) do |args|

    args = [args] unless args.is_a?(Array)

    unless args.length == 2
      raise( Puppet::ParseError,
            "percona_hash_print_section(): wrong number of arguments (#{args.length}; must be 2)")
    end

    hash = args.shift
    section = args.shift

    raise(Puppet::ParseError, 'percona_hash_print_section(): First argument (hash) should be a Hash') unless hash.is_a?(Hash)
    raise(Puppet::ParseError, 'percona_hash_print_section(): Second argument (section) should be a String') unless section.is_a?(String)

    result = []
    hash.each do |key, element|
      # Only print keys for the section we are printing
      # and that have ensure 'present'
      if element[:section] == section and element[:ensure] == 'present'
        if element[:value] == :undef
          result << "#{element[:key]}"
        else
          result << "#{element[:key]} = #{element[:value]}"
        end
      end
    end

    result.sort.join("\n")
  end

end
