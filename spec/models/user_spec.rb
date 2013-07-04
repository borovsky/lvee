#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  it "should have valid function, that and_return valid params for class" do
    u = User.new(User.valid_data)
    assert u.valid?
  end

  it 'full_name should return first name + last name' do
    user = User.new(:first_name => 'X', :last_name => "Y")
    user.full_name.should == 'X Y'
  end

  describe 'authenticate' do
    it 'should login if user have right login, password and activated' do
      u = User.create!(User.valid_data)
      u.activate

      User.authenticate(User.valid_data[:login], User.valid_data[:password])
    end

    it 'should fail if user not activated' do
      u = User.create!(User.valid_data)
      User.authenticate(User.valid_data[:login], User.valid_data[:password])
    end

    it 'should fail if login incorrect' do
      u = User.create!(User.valid_data)
      u.activate
      User.authenticate(User.valid_data[:login]+'other', User.valid_data[:password])
    end

    it 'should fail if password incorrect' do
      u = User.create!(User.valid_data)
      u.activate
      User.authenticate(User.valid_data[:login], User.valid_data[:password] + 'other')
    end
  end

  describe 'active?' do
    it 'should return true if activation code is nil' do
      u = User.new
      u.should_receive(:activation_code).and_return(nil)
      u.active?.should be_true

    end
    it 'should return false if activation code exists' do
      u = User.new
      u.should_receive(:activation_code).and_return('code')
      u.active?.should be_false
    end
  end

  describe 'remember_token?' do
    it 'false if expire_at not exists' do
      u = User.new
      u.stub!(:remember_token_expires_at).and_return(nil)
      assert !u.remember_token?
    end

    it 'false if expire_at exists but expired' do
      u = User.new
      u.stub!(:remember_token_expires_at).and_return(1.day.ago.utc)
      assert !u.remember_token?
    end

    it 'true if expire_at exists and it expires after now' do
      u = User.new
      u.stub!(:remember_token_expires_at).and_return(1.day.from_now.utc)
      assert u.remember_token?
    end
  end

  describe 'remember_me' do
    let(:user) { FactoryGirl.build(:user) }

    it 'should set remember_token_expires_at' do
      user.should_receive(:remember_token_expires_at=)
      user.remember_me
    end

    it 'should set remember_token' do
      user.should_receive(:remember_token=)
      user.remember_me
    end

    it 'should save with no validation' do
      user.should_receive(:save).with(:validate => false)
      user.remember_me
    end
  end

  describe 'forget_me' do
    let(:user) { FactoryGirl.build(:user) }
    it 'should clear remember_token_expires_at' do
      user.should_receive(:remember_token_expires_at=).with(nil)
      user.forget_me
    end

    it 'should clear remember_token' do
      user.should_receive(:remember_token=).with(nil)
      user.forget_me
    end

    it 'should save with no validation' do
      user.should_receive(:save).with(:validate => false)
      user.forget_me
    end
  end

  describe 'admin?' do
    it 'should be true if role is admin' do
      u = User.new
      u.should_receive(:role).and_return('admin')
      u.admin?.should == true
    end

    it 'should be false if role is not admin' do
      u = User.new
      u.should_receive(:role).and_return('user')
      u.admin?.should == false
    end
  end

  describe 'editor?' do
    it 'should be true if role is admin' do
      u = User.new
      u.should_receive(:role).and_return('admin')
      u.editor?.should == true
    end

    it 'should be false if role is not admin' do
      u = User.new
      u.should_receive(:role).and_return('editor')
      u.editor?.should == true
    end

    it 'should be false if role is not admin' do
      u = User.new
      u.should_receive(:role).and_return('user')
      u.editor?.should == false
    end
  end
end
