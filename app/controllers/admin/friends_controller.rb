module Admin
  class FriendsController < ApplicationController
    layout 'admin'
    before_filter :admin_required
    before_filter :load_public_key, :only => [:index]
    before_filter :find_friend, :only => [:edit, :update, :destroy]

    def index
      @friends = Friend.for_list
    end

    def new
      @friend = Friend.new
    end

    def create
      @friend = Friend.new(params[:friend])

      redirect_to admin_friends_path if @friend.save
    end

    def edit
    end

    def update
      redirect_to admin_friends_path if @friend.update_attributes(params[:friend])
    end

    def destroy
      @friend.destroy

      redirect_to admin_friends_path
    end

    private

    def load_public_key
      public_key_file = File.join(Rails.root, "config/friendlist_public.pem")

      @public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file)) if FileTest.exists? public_key_file
    end

    def find_friend
      @friend = Friend.find(params[:id])
    end

  end
end
