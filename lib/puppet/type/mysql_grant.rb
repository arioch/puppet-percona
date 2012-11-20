Puppet::Type.newtype(:mysql_grant) do
  @doc = "Manage a database user's rights."
  #ensurable

  autorequire :mysql_database do
    reqs = []
    matches = self[:name].match(/^([^@]+)@([^\/]+)\/(.+)$/)
    unless matches.nil?
      reqs << matches[3]
    end
    reqs
  end

  autorequire :mysql_user do
    reqs = []
    matches = self[:name].match(/^([^@]+)@([^\/]+).*$/)
    unless matches.nil?
      reqs << "%s@%s" % [ matches[1], matches[2] ]
    end
    reqs
  end

  newparam(:name, :namevar=>true) do
    desc "The primary key: either user@host for global privilges or user@host/database for database specific privileges"
  end

  newparam(:mgmt_cnf) do
    desc "The my.cnf to use for calls."
  end

  newproperty(:privileges, :array_matching => :all) do
    desc "The privileges the user should have. The possible values are implementation dependent."

    def should_to_s(newvalue = @should)
      if newvalue
        unless newvalue.is_a?(Array)
          newvalue = [ newvalue ]
        end
        newvalue.collect do |v| v.downcase end.sort.join ", "
      else
        nil
      end
    end

    def is_to_s(currentvalue = @is)
      if currentvalue
        unless currentvalue.is_a?(Array)
          currentvalue = [ currentvalue ]
        end
        currentvalue.collect do |v| v.downcase end.sort.join ", "
      else
        nil
      end
    end

    # use the sorted outputs for comparison
    def insync?(is)
      if defined? @should and @should
        case self.should_to_s
        when "all"
          self.provider.all_privs_set?
        when self.is_to_s(is)
          true
        else
          false
        end
      else
        true
      end
    end

  end
end

