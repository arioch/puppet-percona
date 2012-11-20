require 'spec_helper'

describe 'percona::install' do

  describe "[Debian] percona::install class, server" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'Debian', :kernel => 'Linux'} }
  end

  describe "[CentOS] percona::install class, server" do
    let(:title) { 'percona' }
    let(:node) { 'percona' }
    let(:facts) { {:operatingsystem => 'CentOS', :kernel => 'Linux'} }
  end
end
