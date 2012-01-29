require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'percona' do
  describe "[Debian] percona class w/o parameters" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }

    it { should create_class("percona") }
    it { should include_class('percona::params') }
    it { should include_class('percona::preinstall') }
    it { should include_class('percona::install') }
    it { should include_class('percona::config') }
    it { should include_class('percona::config::client') }
    it { should include_class('percona::service') }
  end

  describe "[CentOS] percona class w/o parameters" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux'} }

    it { should create_class("percona") }
    it { should include_class('percona::params') }
    it { should include_class('percona::preinstall') }
    it { should include_class('percona::install') }
    it { should include_class('percona::config') }
    it { should include_class('percona::config::client') }
    it { should include_class('percona::service') }
  end

  describe "[Debian] percona class with parameters, server true, no version specified" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }
    let(:params) { {:client => 'true', :server => 'true' } }

    it { should create_class("percona") }
    it { should include_class('percona::config::client') }
    it { should include_class('percona::config::server') }

    it { should contain_package('percona-toolkit').with_ensure('present') }
    it { should contain_package('percona-server-client-5.5').with_ensure('present') }
    it { should contain_package('percona-server-server-5.5').with_ensure('present') }

  end

  describe "[CentOS] percona class with parameters, server true, no version specified" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux'} }
    let(:params) { {:client => 'true', :server => 'true' } }

    it { should create_class("percona") }
    it { should include_class('percona::config::client') }
    it { should include_class('percona::config::server') }

    it { should contain_package('percona-toolkit').with_ensure('present') }
    it { should contain_package('Percona-Server-client-55').with_ensure('present') }
    it { should contain_package('Percona-Server-server-55').with_ensure('present') }
  end

  describe "[Debian] percona class with parameters, server true, version 5.1" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }
    let(:params) { {:client => 'true', :server => 'true', :percona_version => '5.1' } }

    it { should create_class("percona") }
    it { should include_class('percona::config::client') }
    it { should include_class('percona::config::server') }

    it { should contain_package('percona-toolkit').with_ensure('present') }
    it { should contain_package('percona-server-client-5.1').with_ensure('present') }
    it { should contain_package('percona-server-server-5.1').with_ensure('present') }

  end

  describe "[CentOS] percona class with parameters, server true, version 5.1" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux'} }
    let(:params) { {:client => 'true', :server => 'true', :percona_version => '5.1' } }

    it { should create_class("percona") }
    it { should include_class('percona::config::client') }
    it { should include_class('percona::config::server') }

    it { should contain_package('percona-toolkit').with_ensure('present') }
    it { should contain_package('Percona-Server-client-51').with_ensure('present') }
    it { should contain_package('Percona-Server-server-51').with_ensure('present') }
  end

  describe "[Debian] percona class with parameters, server true, version 5.5" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }
    let(:params) { {:client => 'true', :server => 'true', :percona_version => '5.5' } }

    it { should create_class("percona") }
    it { should include_class('percona::config::client') }
    it { should include_class('percona::config::server') }

    it { should contain_package('percona-toolkit').with_ensure('present') }
    it { should contain_package('percona-server-client-5.5').with_ensure('present') }
    it { should contain_package('percona-server-server-5.5').with_ensure('present') }

  end

  describe "[CentOS] percona class with parameters, server true, version 5.5" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux'} }
    let(:params) { {:client => 'true', :server => 'true', :percona_version => '5.5' } }

    it { should create_class("percona") }
    it { should include_class('percona::config::client') }
    it { should include_class('percona::config::server') }

    it { should contain_package('percona-toolkit').with_ensure('present') }
    it { should contain_package('Percona-Server-client-55').with_ensure('present') }
    it { should contain_package('Percona-Server-server-55').with_ensure('present') }
  end

  describe "[Debian] percona class with parameters, server false" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }
    let(:params) { {:client => 'true', :server => 'false' } }

    it { should create_class("percona") }
    it { should include_class('percona::config::client') }
  end

  describe "[CentOS] percona class with parameters, server false" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux'} }
    let(:params) { {:client => 'true', :server => 'false' } }

    it { should create_class("percona") }
    it { should include_class('percona::config::client') }
  end
end
