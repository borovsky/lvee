#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../spec_helper'

describe Status do
  describe 'find_by_name' do
    it 'should search status by name and locale' do
      status = mock()
      Status.expects(:find_first_by_name_and_locale).with('test_status', 'ru').returns(status)
      I18n.expects(:locale).returns(:ru)
      Status.find_by_name('test_status').should == status
    end

    it 'should search status by name and default locale' do
      status = mock()
      Status.expects(:find_first_by_name_and_locale).with('test_status', 'ru').returns(nil)
      I18n.expects(:locale).returns(:ru)
      Status.expects(:find_first_by_name_and_locale).with('test_status', 'en').returns(status)
      I18n.expects(:default_locale).returns(:en)
      Status.find_by_name('test_status').should == status
    end
    it 'should search status by name' do
      status = mock()
      Status.expects(:find_first_by_name_and_locale).with('test_status', 'ru').returns(nil)
      I18n.expects(:locale).returns(:ru)
      Status.expects(:find_first_by_name_and_locale).with('test_status', 'en').returns(nil)
      I18n.expects(:default_locale).returns(:en)
      Status.expects(:find_first_by_name).with('test_status').returns(status)
      Status.find_by_name('test_status').should == status
    end
    it 'should return nil if no status with specified name' do
      status = mock()
      Status.expects(:find_first_by_name_and_locale).with('test_status', 'ru').returns(nil)
      I18n.expects(:locale).returns(:ru)
      Status.expects(:find_first_by_name_and_locale).with('test_status', 'en').returns(nil)
      I18n.expects(:default_locale).returns(:en)
      Status.expects(:find_first_by_name).with('test_status').returns(nil)
      Status.find_by_name('test_status').should be_nil
    end
  end
end
