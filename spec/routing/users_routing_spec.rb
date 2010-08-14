# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  describe 'activate' do
    it "should be accessible by right URL" do
      {:get => '/activate/42'}.should route_to(
        :controller => 'users',
        :action => 'activate',
        :activation_code => '42'
      )
    end
  end

  describe 'show' do
    it "should be accessible by right URL" do
      {:get => '/ru/users/42'}.should route_to(
        :controller => 'users',
        :action => 'show',
        :id=>'42',
        :lang => 'ru'
      )
    end
  end

  describe "current" do
    it "should be accessible by right URL" do
      {:get => '/be/users/current'}.should route_to(
        :controller => 'users',
        :action => 'current',
        :lang => 'be'
      )
    end
  end
end

