class Spec::Rails::Example::FunctionalExampleGroup
  @@next_id = 1
 
  def next_id
    @@next_id += 1
  end
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  def model_stub(model_class, stubs={})
    attrs = model_class.column_names.inject(Hash.new) do|s, i|
      s[i.to_sym] = nil
      s
    end
    def_params = {
      :id => next_id,
      :class => model_class,
      :errors => []
    }
    stubs = attrs.merge(def_params).merge(stubs)
    model = stub("#{model_class} - #{stubs[:id]}")
    stubs.each_pair do |k, v|
      model.stubs(k).returns(v)
    end
    yield model if block_given?
    model
  end
end

class Spec::Rails::Example::ControllerExampleGroup
  def login_as(user)
    controller.stubs(:current_user).returns(user)
  end

  %w(get post put delete head).each do |method|
    class_eval <<-EOV, __FILE__, __LINE__
      def #{method}(action, params = {}, session = nil, flash = nil)
        @request.env['REQUEST_METHOD'] = '#{method.upcase}' if defined?(@request)
        params = {:lang=>'en'}.merge(params)
        process(action, params, session, flash)
      end
    EOV
  end
end

class Spec::Rails::Example::ViewExampleGroup
  def login_as(user)
    template.stubs(:current_user).returns(user)
  end

  before :each do
    params[:lang] = 'en'
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
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end

Array.class_eval do
  alias_method(:count, :length)
end unless [].respond_to?(:count)
