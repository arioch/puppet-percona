require 'spec_helper'

describe 'the percona_hash_print_section function' do

  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    Puppet::Parser::Functions.function('percona_hash_print_section').should == "function_percona_hash_print_section"
  end

  it 'should throw an error with 1 argument' do
    lambda {
      scope.function_percona_hash_print_section(['mysqld'])
    }.should(raise_error(Puppet::ParseError))
  end

  it 'should throw an error with more than 2 arguments' do
    lambda {
      scope.function_percona_hash_print_section(['mysqld',{},{}])
    }.should(raise_error(Puppet::ParseError))
  end

  it 'should throw an error with wrong type for section' do
    lambda {
      hash = {}
      section = {}

      scope.function_percona_hash_print_section([hash,section])
    }.should(raise_error(Puppet::ParseError))
  end

  it 'should throw an error with wrong type for hash' do
    lambda {
      hash = 'failing'
      section = 'mysqld'
      scope.function_percona_hash_print_section([hash,section])
    }.should(raise_error(Puppet::ParseError))
  end

  it 'should not throw any error with the correct arguments' do
    lambda {
      hash = {}
      section = 'section'
      scope.function_percona_hash_print_section([hash,section])
    }.should_not(raise_error(Puppet::ParseError))
  end

  it 'should print out ordened' do
    hash =  {
      'c'        => {:value => 'bar',  :ensure => 'present',  :key => 'c',  :section => 'mysqld',  },
      'a'        => {:value => 'bar',  :ensure => 'present',  :key => 'a',  :section => 'mysqld',  },
      'mysqld/b' => {:value => 'bar',  :ensure => 'present',  :key => 'b',  :section => 'mysqld',  },
    }
    section = 'mysqld'
    scope.function_percona_hash_print_section([hash,section]).should == "a = bar
b = bar
c = bar"

  end

  it 'should print out correct section' do
    hash = {
      'custom/section' => {:value => 'somevalue', :ensure => 'present', :key => 'section', :section => 'custom', },
    }
    section = 'custom'

    scope.function_percona_hash_print_section([hash,section]).should == "section = somevalue"
  end

  it 'should not print out values with absent' do
    hash = {
      'key' => {:value => 'somevalue', :ensure => 'absent', :key => 'key', :section => 'mysqld', },
    }
    section = 'mysqld'
    scope.function_percona_hash_print_section([hash,section]).should == ""
  end

  it 'should repeat keys with an array as value' do
    hash = {
      'key' => {:value => ['one','two'], :ensure => 'present', :key => 'key', :section => 'mysqld', },
    }
    section = 'mysqld'
    scope.function_percona_hash_print_section([hash,section]).should == "key = one
key = two"
  end

end
