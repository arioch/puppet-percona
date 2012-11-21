require 'spec_helper'

describe 'percona::params' do

  let(:title) { 'percona::params' }
  let(:node) { 'percona' }

  ['Debian','CentOS'].each do |operatingsystem|

    describe "on #{operatingsystem}" do
      let(:facts) { {:operatingsystem => operatingsystem, :kernel => 'Linux'} }

      it "have been created" do
        should create_class("percona::params")
      end
    end
  end


end
