require 'rake'
require 'rspec/core/rake_task'
require 'puppetlabs_spec_helper/rake_tasks'

# Remove the default task the puppetlabs-spec-helper provides.
Rake::Task[:default].clear

desc "Run all RSpec code examples"
# Uses spec_prep (creates fixtures)
RSpec::Core::RakeTask.new(:rspec => :spec_prep) do |t|
    t.rspec_opts = File.read("spec/spec.opts").chomp || ""
end
# Cleanup afterwards.
Rake::Task[:rspec].enhance do
  Rake::Task[:spec_clean].invoke
end

# provide split out tasks for functions/classes/...
SPEC_SUITES = (Dir.entries('spec') - ['.', '..','fixtures']).select {|e| File.directory? "spec/#{e}" }
namespace :rspec do
  SPEC_SUITES.each do |suite|
    desc "Run #{suite} RSpec code examples"
    RSpec::Core::RakeTask.new(suite => :spec_prep) do |t|
      t.pattern= "spec/#{suite}/**/*_spec.rb"
      t.rspec_opts = File.read("spec/spec.opts").chomp || ""
    end
    Rake::Task[suite].enhance do
      Rake::Task[:spec_clean].invoke
    end
  end
end

# Default task
task :default => :rspec
