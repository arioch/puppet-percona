require 'rubygems'
require 'rspec-puppet'
require 'spec_helper'
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.module_path = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
  c.manifest_dir = File.expand_path(File.join(File.dirname(__FILE__), '..','manifests'))
  c.formatter = 'documentation'
  c.color = 'true'
end

