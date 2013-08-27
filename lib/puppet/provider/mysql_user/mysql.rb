Puppet::Type.type(:mysql_user).provide(:mysql) do

  desc "Use mysql as database."

  defaultfor :kernel => 'Linux'

  optional_commands :mysql => 'mysql'
  optional_commands :mysqladmin => 'mysqladmin'

  def mysql_args(*args)
    if @resource[:mgmt_cnf].is_a?(String)
      args.insert(0, "--defaults-file=#{@resource[:mgmt_cnf]}")
    elsif File.file?("#{Facter.value(:root_home)}/.my.cnf")
      args.insert(0, "--defaults-file=#{Facter.value(:root_home)}/.my.cnf")
    end
    args
  end

  # retrieve the current set of mysql users
  def self.instances
    users = mysql(mysql_args("mysql", '-BNe' "select concat(User, '@',Host) as User from mysql.user")).split("\n")
    users.select{ |user| user =~ /.+@/ }.collect do |name|
      new(:name => name)
    end
  end

  def mysql_flush
    mysqladmin(mysql_args("flush-privileges"))
  end

  def create
    mysql(mysql_args("mysql", "-e", "create user '%s' identified by PASSWORD '%s'" % [ @resource[:name].sub("@", "'@'"), @resource.should(:password_hash) ]))
    mysql_flush
  end

  def destroy
    mysql(mysql_args("mysql", "-e", "drop user '%s'" % @resource[:name].sub("@", "'@'")))
    mysql_flush
  end

  def exists?
    not mysql(mysql_args("mysql", "-NBe", "select '1' from user where CONCAT(user, '@', host) = '%s'" % @resource[:name])).empty?
  end

  def password_hash
    mysql(mysql_args("mysql", "-NBe", "select password from mysql.user where CONCAT(    user, '@', host) = '%s'" % @resource.value(:name))).chomp
  end

  def password_hash=(string)
    mysql(mysql_args("mysql", "-e", "SET PASSWORD FOR '%s' = '%s'" % [ @resource[:name].sub("@", "'@'"), string ]))
    mysql_flush
  end
end

