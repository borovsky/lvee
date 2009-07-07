
require 'test/unit'
require File.dirname(__FILE__) + "/../../lib/bencode.rb"

class BdecodeDictionaryTest < Test::Unit::TestCase
  def test_empty
    assert_equal Hash.new, "de".bdecode
  end

  def test_single_pair
    assert_equal({"a" => 42}, 'd1:ai42ee'.bdecode)
  end

  def test_multi_pair
    hsh = {"a" => "monkey", "h" => "elephant", "z" => "zebra"}
    assert_equal hsh, "d1:a6:monkey1:h8:elephant1:z5:zebrae".bdecode
  end
end
