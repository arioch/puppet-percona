require 'spec_helper'

describe 'the percona_hash_sections function' do

  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  let(:node) { 'percona' }
  let(:title) { 'percona' }

  it 'should exist' do
    Puppet::Parser::Functions.function('percona_hash_sections').should == "function_percona_hash_sections"
  end

  it 'should throw an error on invalid arguments' do
    lambda {
      scope.function_percona_hash_sections(['string'])
    }.should(raise_error(Puppet::ParseError))
  end

  it 'should accept hashes as arguments' do
    lambda {
      scope.function_percona_hash_sections([{'a' => 'hash'}])
    }.should_not(raise_error(Puppet::ParseError))
  end

  it 'should detect used sections' do
    hash = {
      'foo' => {:section => 'sfoo', :key => 'foo', :value => 'foo', :ensure => 'present', },
      'bar' => {:section => 'sbar', :key => 'bar', :value => 'bar', :ensure => 'present', },
    }
    scope.function_percona_hash_sections([hash]).sort.should == ['sfoo','sbar'].sort
  end

end
