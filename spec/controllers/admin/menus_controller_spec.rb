require 'spec_helper'

describe Admin::MenusController do
  context "#index" do
    context "not logged in" do
      before do
        get :index
      end
      it { should redirect_to new_session_path}
    end
  end
end
