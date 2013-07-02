Puppet::Type.type(:mysql_database).provide(:mysql) do

  desc "Use mysql as database."

  defaultfor :kernel => 'Linux'

  optional_commands :mysqladmin => 'mysqladmin'
  optional_commands :mysql => 'mysql'

  def mysql_args(*args)
    if @resource[:mgmt_cnf].is_a?(String)
      args.insert(0, "--defaults-file=#{@resource[:mgmt_cnf]}")
    elsif File.file?("#{Facter.value(:root_home)}/.my.cnf")
      args.insert(0, "--defaults-file=#{Facter.value(:root_home)}/.my.cnf")
    end
    args
  end

  def self.instances
    mysql(mysql_args('-NBe', "show databases")).split("\n").collect do |name|
      new(:name => name)
    end
  end

  def create
    mysql(mysql_args('-NBe', "create database `#{@resource[:name]}` character set #{resource[:charset]}"))
  end

  def destroy
    mysqladmin(mysql_args('-f', 'drop', @resource[:name]))
  end

  def charset
    mysql(mysql_args('-NBe', "show create database `#{resource[:name]}`")).match(/.*?(\S+)\s\*\//)[1]
  end

  def charset=(value)
    mysql(mysql_args('-NBe', "alter database `#{resource[:name]}` CHARACTER SET #{value}"))
  end

  def exists?
    begin
      mysql(mysql_args('-NBe', "show databases")).match(/^#{@resource[:name]}$/)
    rescue => e
      debug(e.message)
      return nil
    end
  end
end
