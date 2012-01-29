require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'percona::preinstall' do
  describe "[Debian] percona::preinstall class" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }

    it { should create_class("percona::preinstall") }

    it { should contain_exec('apt-get update')\
      .with_command("apt-get update")\
      .with_refreshonly(true)
    }

    it { should contain_apt__key('CD2EFD2A')\
      .with_notify(["Exec[apt-get update]"])
    }

    it { should contain_apt__sources_list('percona')\
      .with_ensure('present')
    }
  end

  describe "[CentOS] percona::preinstall class" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux'} }

    it { should create_class("percona::preinstall") }
    it { should contain_package('percona-release').with_ensure('present') }
  end
end
