class MainController < ApplicationController

  def index
    @news = News.published.find(:all, :limit => 5)
  end

end
