require 'spec_helper'

describe Translation do
  context ".generate_full_tree" do
    it "generate tree of subkeys" do
      Translation.class_eval do
        generate_full_tree("a.b" => "1", "a.c" => "2")
      end.should == {"a.b" => "1", "a.c" => "2", "a" => {"b" => "1", "c" => "2"}}

      Translation.class_eval do
        generate_full_tree("a.b.c" => "1", "a.b.d" => "2")
      end.should == {"a.b.c"=>"1", "a.b.d"=>"2", "a"=>{"b"=>{"c"=>"1", "d"=>"2"}},
        "a.b"=>{"c"=>"1", "d"=>"2"}}
    end
  end
end
