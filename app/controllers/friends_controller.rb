class FriendsController < ApplicationController
  before_filter :load_private_key
  protect_from_forgery :except => [:status, :user_data]

  def status
    unless @private_key
      head :precondition_failed
    else
      hostname = @private_key.private_decrypt([params[:message]].pack("H*"))
      @friend = Friend.first(:conditions => {:hostname => hostname}, :select => 'id, hostname, public_key')
      puts @friend.inspect

      respond_to do |format|
        format.json { render :json => @friend }
      end
    end
  end

  def user_data
    public_key = OpenSSL::PKey::RSA.new(Friend.find_by_hostname(params[:hostname]).public_key)
    login = @private_key.private_decrypt([params[:message]].pack("H*"))

    if @private_key && public_key && public_key.verify(OpenSSL::Digest::SHA1.new, [params[:sign]].pack("H*"), login)
      @user = User.first(:conditions => {:login => login},
                         :select => ('id, login, email, first_name, last_name, country, city, occupation'))

      respond_to do |format|
        format.json { render :json => @user }
      end
    else
      head :precondition_failed
    end
  end

  private

  def load_private_key
    private_key_file = File.join(Rails.root, "config/friendlist_private.pem")
    @private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file)) if FileTest.exists? private_key_file
  end
end
