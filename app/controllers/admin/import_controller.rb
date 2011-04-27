class Admin::ImportController < ApplicationController
  layout "admin"
  before_filter :admin_required

  def index
  end

  def users
    @users = ActiveSupport::JSON.decode(params[:users])
    @local_users = User.all
    @log = []
    @users.each do |u|
      logger.error u['email'].inspect
      f = @local_users.find do |u2|
        u['email'] == u2.email
      end
      if f
        if(f.login == u['login'])
          if(!f.active? && u['activated_at'] && !u['activation_code'])
            f.no_mail = true
            f.activate
            @log << "User #{u['login']} (#{u['email']}) have been activated"
          end
        else
          @log << "User #{u['login']} (#{u['email']}) already registred as #{f.login}"
        end
      else
        logger.error("Creating")
        @log << User.create_imported(u)
      end
    end
  end

  def conference_registrations
    @conference = Conference.find(params[:conference])
    @log = []
    params[:users].each_line do |e|
      e = e.strip
      u = User.find_by_email e
      if(u)
        @log << ConferenceRegistration.create_imported(@conference, u)
      else
        @log << "User with email #{e} not found"
      end
    end
  end

end
