require 'spec_helper'

describe 'the percona_hash_merge function' do

  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  let(:node) { 'percona' }
  let(:title) { 'percona' }

  it 'should exist' do
    Puppet::Parser::Functions.function('percona_hash_merge').should == "function_percona_hash_merge"
  end

  it 'should throw an error on invalid types' do
    lambda {
      class T
      end

      scope.function_percona_hash_merge([{ 'bogus' => T.new}])
    }.should(raise_error(Puppet::ParseError))
  end

  it 'should accept strings as values' do
    lambda {
      scope.function_percona_hash_merge([{'value' => 'string' }])
    }.should_not(raise_error(Puppet::ParseError))
  end

  it 'should accept undef as values' do
    lambda {
      scope.function_percona_hash_merge([{'value' => :undef }])
    }.should_not(raise_error(Puppet::ParseError))
  end

  it 'should accept hashes as values' do
    lambda {
      scope.function_percona_hash_merge([{'value' => {:value => 'hash'} }])
    }.should_not(raise_error(Puppet::ParseError))
  end

  it 'should accept numbers as values' do
    lambda {
      scope.function_percona_hash_merge([{'value' => 1 }])
    }.should_not(raise_error(Puppet::ParseError))
  end

  it 'should accept arrays as values' do
    lambda {
      scope.function_percona_hash_merge([{'value' => ['foo','bar']}])
    }.should_not(raise_error(Puppet::ParseError))
  end

  ['present','absent'].each do |str|
    it "should accept string '#{str}' as a special value" do
      result = {
        'mysqld/value' => {:value => :undef, :ensure => str, :section => 'mysqld', :key => 'value' },
      }
      scope.function_percona_hash_merge([{'value' => str}]).should be_matching(result)
    end
  end

  it 'should convert to resources and set defaults' do
    hash =  {
      'key'         => 'value',
      'proper'      => { :value => 'bar' },
      'empty'       => {},
      'novalue'     => :undef,
      'section/foo' => 'present',
    }

    result = scope.function_percona_hash_merge([hash])
    result.should be_matching({
      'mysqld/key'     => { :value => 'value', :ensure => 'present', :section => 'mysqld', :key => 'key', },
      'mysqld/proper'  => { :value => 'bar',   :ensure => 'present', :section => 'mysqld', :key => 'proper', },
      'mysqld/empty'   => { :value => :undef,  :ensure => 'present', :section => 'mysqld', :key => 'empty'},
      'mysqld/novalue' => { :value => :undef,  :ensure => 'present', :section => 'mysqld', :key => 'novalue', },
      'section/foo'    => { :value => :undef, :ensure => 'present', :section => 'section', :key => 'foo', }
    })

  end

  it 'should detect sections' do
    hash = {
      'custom/section' => 'present',
    }
    result = scope.function_percona_hash_merge([hash])
    result.should be_matching({
      'custom/section' => {:value => :undef, :ensure => 'present', :key => 'section', :section => 'custom', }
    })
  end

  it 'should merge 2 hashes' do
    default_hash =  {
      'in'       => { :value  => 'default', :ensure => 'present',},
      'override' => { :ensure => 'absent',},
      'be-gone'  => { :value  => 'present', :ensure => 'available',},
    }

    hash = {
      'extra'    => { :value  => ['param'], },
      'override' => { :value  => 'overridden', },
      'be-gone'  => { :ensure => 'absent', },
    }

    merged =  {
      'mysqld/in'       => { :value => 'default',    :ensure => 'present', :section => 'mysqld', :key => 'in', },
      'mysqld/extra'    => { :value => ['param'],    :ensure => 'present', :section => 'mysqld', :key => 'extra', },
      'mysqld/override' => { :value => 'overridden', :ensure => 'present', :section => 'mysqld', :key => 'override', },
      'mysqld/be-gone'  => { :value => :undef,       :ensure => 'absent',  :section => 'mysqld', :key => 'be-gone',},
    }

    result = scope.function_percona_hash_merge([hash, default_hash])
    result.should be_matching(merged)
  end

  it 'should merge x hashes' do
    my_hash = {
      'extra' => 'bar',
    }
    x1 = {
      'extra' => 'piew piew',
    }
    x2 = {
      'foo' => {:ensure => 'absent'},
    }
    x3 = {
      'foo' => 'bar',
    }

    merged = {
      'mysqld/foo' =>   {:value => :undef, :ensure => 'absent', :section => 'mysqld', :key => 'foo',},
      'mysqld/extra' => {:value => 'bar', :ensure => 'present', :section => 'mysqld', :key => 'extra',}
    }


    result = scope.function_percona_hash_merge([my_hash, x1, x2, x3])
    result.should be_matching(merged)
  end

  it 'should work for additional params' do
    my_cnf = {
      'user' => {:value => 'root', :section => 'mysql',},
    }
    result = scope.function_percona_hash_merge([my_cnf])
    result.should be_matching({'mysql/user' => {:value => 'root', :section => 'mysql', :ensure => 'present', :key => 'user',}})

  end

  it 'should merge values with and without sections properly' do
    first = {
      'foo' => 'bar',
    }
    second = {
      'mysqld/foo' => 'second',
    }

    result = scope.function_percona_hash_merge([first, second])
    result.should be_matching({'mysqld/foo' => {:value => 'bar', :section => 'mysqld', :ensure => 'present', :key => 'foo' }})


  end

end
