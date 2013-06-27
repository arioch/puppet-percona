require 'spec_helper'

describe 'the percona_hash_sanitize function' do

  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  let(:node) { 'percona' }
  let(:title) { 'percona' }

  it 'should exist' do
    Puppet::Parser::Functions.function('percona_hash_sanitize').should == "function_percona_hash_sanitize"
  end

  it 'should throw an error on invalid types' do
    lambda {
      class T
      end
      scope.function_percona_hash_merge([{ 'bogus' => T.new}])
    }.should(raise_error(Puppet::ParseError))
  end

  it 'should sanitize hash values' do
    hash = {
      'foo' => 'present',
      'bar' => 'absent',
      'with/section' => 'foobar',
      'with/hash' => {:value => 'foobar'},
    }

    result = {
      'mysqld/foo' => {:ensure => 'present', :value => :undef, :section => 'mysqld', :key => 'foo' },
      'mysqld/bar' => {:ensure => 'absent', :value => :undef, :section => 'mysqld', :key => 'bar' },
      'with/section' => {:ensure => 'present', :value => 'foobar', :section => 'with', :key => 'section' },
      'with/hash' => {:ensure => 'present', :value => 'foobar', :section => 'with', :key => 'hash' },
    }

    scope.function_percona_hash_sanitize([hash]).should be_matching(result)

  end

end
