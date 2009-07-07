
require 'test/unit'
require "#{File.dirname(__FILE__)}/../../lib/bencode.rb"

class BencodeListTest < Test::Unit::TestCase
  # Asserts that an empty array is encoded correctly.
  def test_empty
    assert_equal 'le', [].bencode
  end

  # Asserts that arrays of integers are encoded correctly.
  def test_integer_list
    assert_equal 'li1ee', [1].bencode
    assert_equal 'li1ei2ei3ei4ee', [1, 2, 3, 4].bencode
  end

  # Asserts that trying to encode a list containing a
  # floating point number raises a +BEncode::EncodeError+.
  def test_float_list
    assert_raise BEncode::EncodeError do
      [13.37].bencode
    end
  end

  def test_string_list
    assert_equal 'l3:fooe', %w[foo].bencode
    assert_equal 'l1:a1:b1:ce', %w[a b c].bencode
  end

  def test_list_list
    assert_equal 'llee', [[]].bencode
    assert_equal 'llleee', [[[]]].bencode
    assert_equal 'llelelee', [[], [], []].bencode
  end

  # Asserts that a recursive array is not bencoded.
  # TODO: Uses waaaaay too much time. What to do?
  def _test_recursive_list
    assert_raise BEncode::EncodeError do
      list = []
      list << list
      list.bencode
    end

    assert_raise BEncode::EncodeError do
      list = [[]]
      list.first << list
      list.bencode
    end
  end

  def test_dict_list
    assert_equal 'ldee', [{}].bencode
  end
end
