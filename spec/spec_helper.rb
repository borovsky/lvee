# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'
require 'i18n'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end

class Spec::Rails::Example::FunctionalExampleGroup
  @@next_id = 1

  def next_id
    @@next_id += 1
  end

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
end

Array.class_eval do
  alias_method(:count, :length)
end unless [].respond_to?(:count)
