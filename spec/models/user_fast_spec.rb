#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  it "should have valid function, that returns valid params for class" do
    assert User.new(User.valid_data).valid?
  end

  it 'full_name should return first name + last name' do
    user = User.new(:first_name => 'X', :last_name => "Y")
    user.full_name.should == 'X Y'
  end

  it 'activate should activate user' do
    
  end
end
