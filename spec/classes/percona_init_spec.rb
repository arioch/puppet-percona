require 'spec_helper'

describe 'percona' do

  describe "[Debian] percona class w/o parameters" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux' } }

    it do
      should create_class("percona")
      should include_class('percona::params')
      should include_class('percona::preinstall')
      should include_class('percona::install')
      should include_class('percona::config')
      should include_class('percona::service')
    end
  end

  describe "[CentOS] percona class w/o parameters" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux'} }

    it do
      should create_class("percona")
      should include_class('percona::params')
      should include_class('percona::preinstall')
      should include_class('percona::install')
      should include_class('percona::config')
      should include_class('percona::service')
    end
  end

  describe "[Debian] percona class with parameters, server true, no version specified" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }
    let(:params) { {:client => true, :server => true } }
 
    it do
      should create_class("percona")
      should include_class('percona::config')
      should include_class('percona::config::server')

      should contain_package('percona-toolkit').with_ensure('present')
      should contain_package('percona-server-client-5.1').with_ensure('present')
      should contain_package('percona-server-server-5.1').with_ensure('present')
    end
  end

  describe "[CentOS] percona class with parameters, server true, no version specified" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux', :ipaddress => '10.0.0.1', } }
    let(:params) { {:client => true, :server => true } }

    it do
      should create_class("percona")

      should include_class('percona::config')
      should include_class('percona::config::server')

      should contain_package('percona-toolkit').with_ensure('present')
      should contain_package('Percona-Server-client-51').with_ensure('present')
      should contain_package('Percona-Server-server-51').with_ensure('present')
    end
  end

  describe "[Debian] percona class with parameters, server true, version 5.1" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }
    let(:params) { {:client => true, :server => true, :percona_version => '5.1' } }

    it do
      should create_class("percona")
      should include_class('percona::config')
      should include_class('percona::config::server')

      should contain_package('percona-toolkit').with_ensure('present')
      should contain_package('percona-server-client-5.1').with_ensure('present')
      should contain_package('percona-server-server-5.1').with_ensure('present')
    end
  end

  describe "[CentOS] percona class with parameters, server true, version 5.1" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux', :ipaddress => '127.0.0.1', } }
    let(:params) { {:client => true, :server => true, :percona_version => '5.1' } }

    it do
      should create_class("percona")
      should include_class('percona::config')
      should include_class('percona::config::server')

      should contain_package('percona-toolkit').with_ensure('present')
      should contain_package('Percona-Server-client-51').with_ensure('present')
      should contain_package('Percona-Server-server-51').with_ensure('present')
    end
  end

  describe "[Debian] percona class with parameters, server true, version 5.5" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }
    let(:params) { {:client => true, :server => true, :percona_version => '5.5' } }

    it do
      should create_class("percona")
      should include_class('percona::config')
      should include_class('percona::config::server')

      should contain_package('percona-toolkit').with_ensure('present')
      should contain_package('percona-server-client-5.5').with_ensure('present')
      should contain_package('percona-server-server-5.5').with_ensure('present')
    end
  end

  describe "[CentOS] percona class with parameters, server true, version 5.5" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux', :ipaddress => '127.0.0.1', } }
    let(:params) { {:client => true, :server => true, :percona_version => '5.5' } }

    it do
      should create_class("percona")
      should include_class('percona::config')
      should include_class('percona::config::server')

      should contain_package('percona-toolkit').with_ensure('present')
      should contain_package('Percona-Server-client-55').with_ensure('present')
      should contain_package('Percona-Server-server-55').with_ensure('present')
    end
  end

  describe "[Debian] percona class with parameters, server false" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }
    let(:params) { {:client => true, :server => false } }

    it do
      should create_class("percona")
      should include_class('percona::install')
      should include_class('percona::config')
      should_not include_class('percona::config::server')
    end
  end

  describe "[CentOS] percona class with parameters, server false" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux', :ipaddress => '127.0.0.1', } }
    let(:params) { {:client => true, :server => false } }

    it do
      should create_class("percona")
      should include_class('percona::config')
      should include_class('percona::install')
      should_not include_class('percona::config::server')
    end
  end
end
