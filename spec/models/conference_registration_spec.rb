#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../spec_helper'

describe ConferenceRegistration do
  describe 'status' do
    it 'should return status by status name' do
      cr = ConferenceRegistration.new(:status_name => 'test')
      status = stub('status');
      Status.expects(:find_by_name).returns(status)
      cr.status
    end
  end

  describe 'status=' do
    it 'should set status name by status' do
      cr = ConferenceRegistration.new()
      status = mock()
      status.expects(:name).returns('status')
      cr.expects(:status_name=).with('status')
      cr.status=status
    end
  end
end
