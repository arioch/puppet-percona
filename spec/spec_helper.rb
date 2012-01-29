require 'rspec-puppet'
require 'spec_helper'

RSpec.configure do |c|
  #c.module_path = '../../'
  c.module_path = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
  c.manifest_dir = File.expand_path(File.join(File.dirname(__FILE__), '..','manifests'))
end
