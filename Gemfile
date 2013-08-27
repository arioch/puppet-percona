source 'https://rubygems.org'

group :rake do
  gem 'rake'
  gem 'puppet-lint', '>=0.2.0'
  gem 'rspec'
  gem 'rspec-expectations'
  gem 'rspec-puppet', '>=0.1.3'

  puppetversion = ENV.key?('PUPPET_VERSION') ? "~> #{ENV['PUPPET_VERSION']}" : ['>= 2.7']
  gem 'puppet', puppetversion
  gem 'puppetlabs_spec_helper', '>=0.2.0'

  gem 'diff_matcher'

  gem 'puppet-blacksmith'
end

group :vagrant do
  gem 'guard'
  gem 'guard-shell', '>= 0.4.0'
  gem 'libnotify' if RUBY_PLATFORM.downcase.include?("linux")
  gem 'growl' if RUBY_PLATFORM.downcase.include?("darwin")
end

