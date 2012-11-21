module Puppet::Parser::Functions

  newfunction(:percona_hash_sections, :type => :rvalue, :doc => <<-EODOC

  Detects all the used sections in a hash.

EODOC
  ) do |args|

    args = [args] unless args.is_a?(Array)
    unless args.length == 1
      raise(Puppet::ParseError, 'percona_hash_sections(): excepts a single argument.')
    end
    hash = args.shift
    unless hash.is_a?(Hash)
      raise(Puppet::ParseError, 'percona_hash_sections(): argument is not a hash.')
    end

    sections = []
    hash.each do |key,value|
      sections << value[:section] unless sections.include?(value[:section])
    end
    sections

  end
end
