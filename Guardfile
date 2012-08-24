# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
guard :shell do
    watch /(.*\.pp$)/ do |m|
        parser = `puppet parser validate --color=false #{m[0]}`
        retval = $?.to_i
        case retval
            when 0
                n "#{m[0]} Parser can parse!", 'Puppet-Parser'
            else
                n "#{m[0]} Parser can't parse! #{parser}", 'Puppet-Parser', :failed
        end
        lint = `puppet-lint --with-filename #{m[0]}`
        retval = $?.to_i
        case retval
            when 0
                if lint.length > 0 then
                    puts lint
                    n "#{m[0]} You can do better, warnings left on Terminal!", 'Puppet-Lint', :pending
                else
                    puts lint
                    n "#{m[0]} Fully lintified!", 'Puppet-Lint', :success
                end
            else
                puts lint
                n "#{m[0]} There are errors on Terminal left!", 'Puppet-Lint', :failed
        end
    end
    watch /(.*\.erb$)/ do |m|
        case system "cat #{m[0]} | erb -P -x -T - | ruby -c"
            when true
                n "#{m[0]} is valid", 'ERB-Check'
            when false
                n "#{m[0]} is invalid", 'ERB-Check', :failed
        end
    end
    watch /(.*\.rb$)/ do |m|
        case system "ruby -c #{m[0]}"
            when true
                n "#{m[0]} is valid", 'Ruby-Syntax-Check'
            when false
                n "#{m[0]} is invalid", 'Ruby-Syntax-Check', :failed
        end
    end
end

# vim: set syntax=ruby
