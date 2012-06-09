#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../spec_helper'

describe ConferenceRegistration do
  describe 'status' do
    it 'should return status by status name' do
      cr = ConferenceRegistration.new({:status_name => 'test'},
                                      without_protection: true)
      status = stub('status');
      Status.should_receive(:find_by_name).and_return(status)
      cr.status
    end
  end

  describe 'status=' do
    it 'should set status name by status' do
      cr = ConferenceRegistration.new()
      status = mock()
      status.should_receive(:name).and_return('status')
      cr.should_receive(:status_name=).with('status')
      cr.status=status
    end
  end
end
