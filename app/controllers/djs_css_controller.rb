class DjsCssController < ApplicationController

  def ie_fuck
    render :template => "djs_css/ie_fuck.js.erb", :mime_type => :js, :layout => false
  end

end
