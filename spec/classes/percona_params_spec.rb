require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'percona::params' do
  describe "[Debian] percona::params class" do
    let(:title) { 'percona::params' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }

    it { should create_class("percona::params") }
  end

  describe "[CentOS] percona::params class" do
    let(:title) { 'percona::params' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux'} }

    it { should create_class("percona::params") }
  end
end
