# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UsersController do
  describe "route recognition" do
    it "should generate params for #index" do
      {:get => '/ru/admin/users'}.should route_to(
        :controller => 'admin/users',
        :action => 'index',
        :lang => 'ru'
      )
      {:get => '/ru/admin/users.csv'}.should route_to(
        :controller => 'admin/users',
        :action => 'index',
        :format => 'csv',
        :lang => 'ru'
      )
    end

    it "should generate params for #set_role" do
      {:post => '/ru/admin/users/42/set_role'}.should route_to(
        :controller => 'admin/users',
        :action => 'set_role',
        :id=>'42',
        :lang => 'ru'
      )
    end
    
    it "should generate params for #destroy" do
      {:delete => '/ru/admin/users/42'}.should route_to(
        :controller => 'admin/users',
        :action => 'destroy',
        :id=>'42',
        :lang=> 'ru'
      )
    end

  end
end

