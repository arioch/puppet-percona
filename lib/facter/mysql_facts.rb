#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#  Author: Jan Vansteenkiste <jan@vstone.eu>

## Caching the output of mysqld --help --verbose
@the_config_settings = nil

## Use regular expressions on the config file for our special variables.
def create_perconapuppet_fact(factname, varname)
  Facter.add(factname) do
    confine :kernel => :linux
    re = Regexp.new("^#-puppet-##{varname}[\s=]+([^ ]+)$")
    setcode do
      value = nil
      configfile = Facter.value(:mysqld_configfile)
      if File.readable?(configfile) and
        Facter::Util::Resolution.exec("cat #{configfile}").match re
        value = $1
      end
      value
    end
  end
end

## Parse the output of mysqld --help --verbose for determining a value.
def create_mysqld_fact_mysqldhelp(factname, varname)
  Facter.add(factname) do
    confine :kernel => :linux
    setcode do
      if @the_config_settings == nil
        @the_config_settings = %x{/usr/sbin/mysqld --help --verbose --pid-file=/tmp/facter-mysqld-dummy.pid --log-bin=/dev/null 2>/dev/null}
      end
      re = Regexp.new("^#{varname}\\s+([^ ]+)$")
      if @the_config_settings.match re
        value = $1
        value = :undef if $1 == 'undefined'
        value = true if $1 == 'TRUE'
        value = false if $1 == 'FALSE'
        value = :undef if $1 == '(No default value)'
        value
      else
        nil
      end
    end
  end
end

## Use augeas to get the value from the config file.
def create_mysqld_fact_augeas(factname, varname, default, section='mysqld')
  Facter.add(factname) do
    confine :kernel => :linux
    setcode do
      value = nil
      ## The config file.
      cfg = Facter.value(:mysqld_configfile)
      # Is there a config file?
      if cfg
        begin
          require 'augeas'
          # We do not preload all the lenses. This is too slow and
          # we will be only using one anyhow.
          aug = Augeas::open('/', '/usr/share/augeas/lenses', Augeas::NO_MODL_AUTOLOAD)
          # Use the mysql lens and include the config file.
          aug.transform(:lens => 'Mysql.lns', :incl => cfg)
          # Load the file
          aug.load()
          # Get the variable we are after
          Facter.debug("xpath: /files/#{cfg}/*[ . = '#{section}']/#{varname}")
          value = aug.get("/files/#{cfg}/*[ . = '#{section}']/#{varname}")
          # Close augeas down.
          aug.close()
          ## If the var is not found, use the default.
          if value == nil
            value = default
          end
        rescue Exception
          Facter.debug("ruby-augeas is required (and is not installed) for fact #{factname}")
        end
      end
      value
    end
  end
end

Facter.add(:mysqld_configfile) do
  confine :kernel => :linux
  setcode do
    value = nil
    [
      '/etc/my.cnf',
      '/etc/mysql.cnf',
      '/etc/mysql/my.cnf',
    ].each do |file|
      if File.exists?(file)
        value = file
        break
      end
    end
    value
  end

end

if Facter.value(:mysqld_configfile)

  create_perconapuppet_fact('percona_servername', 'servername')
  create_perconapuppet_fact('percona_logdir', 'logdir')

  # We can not parse this from mysqld --help since mysql changes
  # to this directory before executing anything, resulting in '.'
  create_mysqld_fact_augeas('mysqld_datadir','datadir','/var/lib/mysql', 'mysqld')

end

if File.exists?('/usr/sbin/mysqld')
  create_mysqld_fact_mysqldhelp('mysqld_tmpdir', 'tmpdir')
  # This fact has been removed due to issue #3. It does not provide correct information
  # create_mysqld_fact_mysqldhelp('mysqld_pidfile', 'pid-file')
  create_mysqld_fact_mysqldhelp('mysqld_socket', 'socket')
  create_mysqld_fact_mysqldhelp('mysqld_server_id', 'server-id')
  create_mysqld_fact_mysqldhelp('mysqld_ssl', 'ssl')
end
