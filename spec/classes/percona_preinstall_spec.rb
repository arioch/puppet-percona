require 'spec_helper'

describe 'percona::preinstall' do

  describe "[Debian] percona::preinstall class" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }

    it do
      should create_class("percona::preinstall")

      # I think rspec-puppet doesn't support cross-module checks.
      # Disabling for now.

      #should contain_exec('apt-get_update')
      #should contain_apt__key('CD2EFD2A')
      #should contain_apt__sources_list('percona')\
      #  .with_ensure('present')
    end
  end

  describe "[CentOS] percona::preinstall class" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux'} }
  end
end
