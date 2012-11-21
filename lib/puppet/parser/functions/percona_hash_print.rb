module Puppet::Parser::Functions

  newfunction(:percona_hash_print, :type => :rvalue, :doc => <<-EODOC

  Prints out a percona hash including the section heads. You can specify which
  sections you want to print as a second argument. If it is not provided, all
  sections will be printed that have been found in the hash.

EODOC
  ) do |args|

    Puppet::Parser::Functions.autoloader.load(:percona_hash_print_section) unless \
      Puppet::Parser::Functions.autoloader.loaded?(:percona_hash_print_section)

    args = [args] unless args.is_a?(Array)
    unless [1,2].include?(args.length)
      raise(Puppet::ParseError, "percona_hash_print(): wrong number of arguments (got #{args.length}, expected 1 or 2)")
    end

    hash = args.shift
    sections = args.shift
    sections = [sections] if sections.is_a?(String)
    if sections == nil
      ## Make sure the function we want to use is loaded.
      Puppet::Parser::Functions.autoloader.load(:percona_hash_sections) unless \
        Puppet::Parser::Functions.autoloader.loaded?(:percona_hash_sections)
      # Get all them sections from the hash.
      sections = function_percona_hash_sections([hash])
    end

    unless hash.is_a?(Hash)
      raise(Puppet::ParseError, 'percona_hash_print(): first argument should be a hash.')
    end
    unless sections.is_a?(Array)
      raise(Puppet::ParseError, 'percona_hash_print(): second argument should be absent, a string or an array.')
    end

    results = []
    sections.sort.each do |sec|
      tmp = []
      tmp << "[#{sec}]"
      tmp << function_percona_hash_print_section([hash,sec])
      tmp << ""
      tmp.flatten!
      results << tmp.join("\n")
    end

    results.join("\n")
  end

end
