
require 'test/unit'
require "#{File.dirname(__FILE__)}/../../lib/bencode.rb"

class BencodeDictionaryTest < Test::Unit::TestCase
  def test_empty
    assert_equal 'de', {}.bencode
  end

  def test_integer_hash
    assert_equal 'd1:ai1ee', {'a' => 1}.bencode
    assert_equal 'd1:ai1e1:bi2e1:ci3ee', 
                 {'a' => 1, 'b' => 2, 'c' => 3}.bencode
  end

  def test_illegal_keys
    assert_raise BEncode::EncodeError do
      {1 => 'foo'}.bencode
    end
  end

  # Thank you, Julien
  def test_key_order
    assert_equal 'd1:ai1e2:bbi3e1:ci2ee', 
                 {'a' => 1, 'c' => 2, 'bb' => 3}.bencode
  end
end
