require 'spec_helper'

describe ThesisesController do

  def valid_attributes
    {title: "test", authors: "a", abstract: "ab",
      body: "test", change_summary: "123",
      conference_id: @conference.id, author_id: @user.id, user_ids: [@user.id]}
  end

  before do
    @user = User.new(:first_name => "Test1", :last_name => "Test2")
    @user.save(:validate => false)
    login_as @user
    @conference = Conference.new(:name => "test")
    @conference.save!(:validate => false)
    @conference_registration = ConferenceRegistration.new(:user_id => @user.id, :conference_id => @conference.id)
    @conference_registration.save!(:validate => false)
  end

  describe "GET index" do
    it "assigns all thesises as @thesises" do
      thesis = Thesis.create!(valid_attributes.merge(:ready_for_review => true), :without_protection => true)
      get :index
      assigns(:thesises).should eq([thesis])
    end
  end

  describe "GET show" do
    it "assigns the requested thesis as @thesis" do
      thesis = Thesis.create!(valid_attributes, :without_protection => true)
      get :show, :id => thesis.id.to_s
      assigns(:thesis).should eq(thesis)
    end
  end

  describe "GET edit" do
    it "assigns the requested thesis as @thesis" do
      thesis = Thesis.create!(valid_attributes, :without_protection => true)
      get :edit, :id => thesis.id.to_s
      assigns(:thesis).should eq(thesis)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Thesis" do
        expect {
          post :create, :thesis => valid_attributes
        }.to change(Thesis, :count).by(1)
      end

      it "assigns a newly created thesis as @thesis" do
        post :create, :thesis => valid_attributes
        assigns(:thesis).should be_a(Thesis)
        assigns(:thesis).should be_persisted
      end

      it "redirects to the created thesis" do
        post :create, :thesis => valid_attributes
        response.should redirect_to(Thesis.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved thesis as @thesis" do
        # Trigger the behavior that occurs when invalid params are submitted
        Thesis.any_instance.stub(:save).and_return(false)
        post :create, :thesis => {}
        assigns(:thesis).should be_a_new(Thesis)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Thesis.any_instance.stub(:save).and_return(false)
        post :create, :thesis => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before do
        @reg = stub_model(ConferenceRegistration, :user_id => @user.id)
        Thesis.any_instance.stub!(:conference_registration).and_return(@reg)
      end
      
      it "updates the requested thesis" do
        thesis = Thesis.create!(valid_attributes, :without_protection => true)
        # Assuming there are no other thesises in the database, this
        # specifies that the Thesis created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Thesis.any_instance.should_receive(:update_attributes).with({'these' => 'params', "author" => @user})
        put :update, :id => thesis.id, :thesis => {'these' => 'params'}
      end

      it "assigns the requested thesis as @thesis" do
        thesis = Thesis.create!(valid_attributes, :without_protection => true)
        put :update, :id => thesis.id, :thesis => valid_attributes
        assigns(:thesis).should eq(thesis)
      end

      it "redirects to the thesis" do
        thesis = Thesis.create!(valid_attributes, :without_protection => true)
        put :update, :id => thesis.id, :thesis => valid_attributes
        response.should redirect_to(Thesis.last)
      end
    end

    describe "with invalid params" do
      it "assigns the thesis as @thesis" do
        thesis = Thesis.create!(valid_attributes, :without_protection => true)
        # Trigger the behavior that occurs when invalid params are submitted
        Thesis.any_instance.stub(:save).and_return(false)
        put :update, :id => thesis.id.to_s, :thesis => {}
        assigns(:thesis).should eq(thesis)
      end

      it "re-renders the 'edit' template" do
        thesis = Thesis.create!(valid_attributes, :without_protection => true)
        thesis.users << @user
        # Trigger the behavior that occurs when invalid params are submitted
        Thesis.any_instance.stub(:save).and_return(false)
        put :update, :id => thesis.id.to_s, :thesis => {}
        response.should render_template("edit")
      end
    end
  end

  #describe "DELETE destroy" do
  #  it "destroys the requested thesis" do
  #    thesis = Thesis.create!(valid_attributes, :without_protection => true)
  #    expect {
  #      delete :destroy, :id => thesis.id.to_s
  #    }.to change(Thesis, :count).by(-1)
  #  end
  #
  #  it "redirects to the thesises list" do
  #    thesis = Thesis.create!(valid_attributes, :without_protection => true)
  #    delete :destroy, :id => thesis.id.to_s
  #    response.should redirect_to(thesises_url)
  #  end
  #end

end
