require 'spec_helper'

describe 'the percona_hash_print function' do

  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    Puppet::Parser::Functions.function('percona_hash_print').should == "function_percona_hash_print"
  end

  it 'should throw an error with more than 2 arguments' do
    expect {
      scope.function_percona_hash_print([{'a' => 'hash',},{},'foobar'])
    }.to raise_error(Puppet::ParseError)
  end

  it 'should throw an error with wrong type for section' do
    expect {
      hash = {}
      section = {}
      scope.function_percona_hash_print([hash, section])
    }.to raise_error(Puppet::ParseError)
  end

  it 'should throw an error with wrong type for hash' do
    expect {
      hash = 'a string?'
      section = 'section'
      scope.function_percona_hash_print([hash, section])
    }.to raise_error
  end

  it 'should not throw an error with 1 argument' do
    expect {
      hash = {}
      scope.function_percona_hash_print([hash])
    }.not_to raise_error
  end

  it 'should not throw any error with 2 arguments and section is a string' do
    expect {
      hash = {}
      section = 'string'
      scope.function_percona_hash_print([hash, section])
    }.not_to raise_error
  end

  it 'should not throw any error with 2 arguments and section is an array' do
    expect {
      hash = {}
      section = ['foo','bar']
      scope.function_percona_hash_print([hash, section])
    }.not_to raise_error
  end

  it 'should print out ordened' do
    hash = {
      'c' => {:value => 'bar',  :ensure => 'present',  :key => 'c',  :section => 'mysqld',  },
      'a' => {:value => 'bar',  :ensure => 'present',  :key => 'a',  :section => 'mysqld',  },
      'b' => {:value => 'bar',  :ensure => 'present',  :key => 'b',  :section => 'mysqld',  }
    }
    section = 'mysqld'

    scope.function_percona_hash_print([hash, section]).should == "[mysqld]
a = bar
b = bar
c = bar
"
  end

  it 'should print out all sections'  do
    hash = {
      'sec1/c' => {:value => :undef,  :ensure => 'present',  :key => 'c',  :section => 'sec1',},
      'sec2/a' => {:value => :undef,  :ensure => 'present',  :key => 'a',  :section => 'sec2',},
      'sec2/b' => {:value => :undef,  :ensure => 'present',  :key => 'b',  :section => 'sec2',},
      'sec3/b' => {:value => :undef,  :ensure => 'present',  :key => 'b',  :section => 'sec3',},
    }
    scope.function_percona_hash_print([hash]).should == "[sec1]
c

[sec2]
a
b

[sec3]
b
"

  end

  it 'should print out some sections' do
    hash = {
      'sec1/c' => {:value => :undef,  :ensure => 'present',  :key => 'c',  :section => 'sec1',},
      'sec2/a' => {:value => :undef,  :ensure => 'present',  :key => 'a',  :section => 'sec2',},
      'sec2/b' => {:value => :undef,  :ensure => 'present',  :key => 'b',  :section => 'sec2',},
      'sec3/b' => {:value => :undef,  :ensure => 'present',  :key => 'b',  :section => 'sec3',},
    }
    sections = ['sec1', 'sec3']
    scope.function_percona_hash_print([hash, sections]).should == "[sec1]
c

[sec3]
b
"
  end

end
