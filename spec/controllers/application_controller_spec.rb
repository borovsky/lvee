require 'spec_helper'

describe ApplicationController do
  context "#accepted_languages" do
    it "should return empty list if no header" do
      @controller.instance_eval do
        accepted_languages(nil).should == []
      end
    end

    it "should order languages by priority" do
      @controller.instance_eval do
        accepted_languages("en-us;q=0.7,en;q=0.5").should == [['en', 0.5], ['en', 0.7]]
      end
    end

    it "should set maximal priority for lang without quality" do
      @controller.instance_eval do
        accepted_languages("en-us,en;q=0.5").should == [['en', 0.5], ['en', 1.0]]
      end
    end
  end

  context "#preferred_language" do
    it "should select most required language" do
      @controller.stub(:accepted_languages).and_return([['en', 0.5], ['de', 1.0]])
      @controller.instance_eval do
        preferred_language(['en', 'de'], 'ru').should == 'de'
      end
    end

    it "should filter out not supported languages" do
      @controller.stub(:accepted_languages).and_return([['en', 0.5], ['de', 1.0]])
      @controller.instance_eval do
        preferred_language(['en'], 'ru').should == 'en'
      end
    end

    it "should select default language if no alternatives" do
      @controller.stub(:accepted_languages).and_return([])
      @controller.instance_eval do
        preferred_language(['en', 'de'], 'ru').should == 'ru'
      end
    end
  end

  context "#cache_result_for" do
    before :each do
      @cache_key = stub(:cache_key)
      @controller.should_receive(:fragment_cache_key).with("key").and_return(@cache_key)
      @time_now = stub(:time_now)
      @result = stub(:result)
      @marshal = stub(:marshal)
      Time.stub(:now).and_return(@time_now)
      @cache = stub(:cache)
      @time = stub(:time)
    end

    it "should render result if it not in cache" do
      @controller.should_receive(:read_fragment).with(@cache_key).and_return(nil)
      Marshal.should_receive(:dump).with([@time_now, @result]).and_return(@marshal)
      @controller.should_receive(:write_fragment).with(@cache_key, @marshal)

      executed_yield = false
      result = @result
      @controller.instance_eval do
        cache_result_for("key", 10.seconds) do
          executed_yield = true
          result
        end.should == result
      end
      executed_yield.should be_true
    end

    it "should render result if it expired" do
      @controller.should_receive(:read_fragment).with(@cache_key).and_return(@cache)
      Marshal.should_receive(:load).with(@cache).and_return([@time, "other result"])
      Marshal.should_receive(:dump).with([@time_now, @result]).and_return(@marshal)
      @controller.should_receive(:write_fragment).with(@cache_key, @marshal)

      executed_yield = false
      result = @result
      ago = stub(ago)
      timeout = stub(timeout, ago: ago)
      @time.should_receive(:>).with(ago).and_return(false)
      @controller.instance_eval do
        cache_result_for("key", timeout) do
          executed_yield = true
          result
        end.should == result
      end
      executed_yield.should be_true
    end

    it "should return result from cache if it not outdated" do
      @controller.should_receive(:read_fragment).with(@cache_key).and_return(@cache)
      Marshal.should_receive(:load).with(@cache).and_return([@time, "other result"])

      executed_yield = false
      result = @result
      ago = stub(ago)
      timeout = stub(timeout, ago: ago)
      @time.should_receive(:>).with(ago).and_return(true)
      @controller.instance_eval do
        cache_result_for("key", timeout) do
          executed_yield = true
          result
        end.should == "other result"
      end
      executed_yield.should be_false
    end
  end

  context '#language_select' do
    it "should redirect out if no language available" do
      I18n.should_receive(:available_locales).and_return([:en, :ru])
      @controller.params.should_receive(:[]).with(:lang).and_return('zz')
      @controller.session.should_receive(:[]=).with(:lang, nil)
      @controller.should_receive(:redirect_to).with('/')
      @controller.instance_eval do
        language_select
      end
    end

    it "should redirect using language mapping" do
      @controller.params.should_receive(:[]).with(:lang).and_return('by')
      r = stub(:redirect)
      @controller.should_receive(:params_to_lang).with('be').and_return(r)
      @controller.should_receive(:redirect_to).with(r)
      @controller.instance_eval do
        language_select
      end
    end
  end

  context "#not_found_error_handler" do
    it "should redirect to new path if redirect exists" do
      red = FactoryGirl.create(:not_found_redirect)
      @controller.request.should_receive(:path).and_return("/be/#{red.path}")
      @controller.should_receive(:redirect_to).with("/be/#{red.target}")
      @controller.instance_eval do
        not_found_error_handler
      end
    end

    it "should render error page if no redirect" do
      @controller.request.should_receive(:path).and_return("/be/other_path")
      @controller.should_receive(:render).
        with(file: "#{Rails.root}/public/404.html", status: 404, layout: false)
      @controller.instance_eval do
        not_found_error_handler
      end
    end
  end
end
