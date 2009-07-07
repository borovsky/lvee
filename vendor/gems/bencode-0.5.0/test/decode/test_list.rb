
require 'test/unit'
require "#{File.dirname(__FILE__)}/../../lib/bencode.rb"

class BdecodeListTest < Test::Unit::TestCase
  def test_empty
    assert_equal [], 'le'.bdecode
  end

  def test_string_list
    assert_equal %w[foo], 'l3:fooe'.bdecode
    assert_equal %w[a b c], 'l1:a1:b1:ce'.bdecode
  end

  def test_integer_list
    assert_equal [0], 'li0ee'.bdecode
    assert_equal [1, 2, 3], 'li1ei2ei3ee'.bdecode
  end

  def test_list_list
    assert_equal [[]], 'llee'.bdecode
    assert_equal [[], [], []], 'llelelee'.bdecode
  end
end
