module RSpec::Rails::ControllerExampleGroup
  def login_as(user)
    controller.stub!(:current_user).any_number_of_times.and_return(user)
  end

  %w(get post put delete head).each do |method|
    class_eval <<-EOV, __FILE__, __LINE__
      def #{method}(action, params = {}, session = nil, flash = nil)
        params = {:lang=>'en'}.merge(params)
        super(action, params, session, flash)
      end
    EOV
  end
end

module RSpec::Rails::ViewExampleGroup
  def login_as(user)
    view.stub!(:current_user).and_return(user)
  end

  included do
    before :each do
      params[:lang] = 'en'
    end
  end
end

I18n.class_eval(<<-END
  class << self
    def translate(key, options = {})
      locale = options.delete(:locale) || I18n.locale
      backend.translate(locale, key, options)
    end

  end
  END
)

module Kernel
  #Doesn't exec any commands
  def system(*args)
  end
end

module ActionView::Helpers::TranslationHelper
  def translate(key, options = {})
    I18n.translate(key, options)
  end

  def t(key, options = {})
    I18n.translate(key, options)
  end
end

Array.class_eval do
  alias_method(:count, :length)
end unless [].respond_to?(:count)

class ActionView::TestCase
  class TestController
    def default_url_options
      {:lang => 'by'}
    end
  end
end