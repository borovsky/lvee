
require 'test/unit'
require "#{File.dirname(__FILE__)}/../../lib/bencode.rb"

class BencodeStringTest < Test::Unit::TestCase
  def test_empty
    assert_equal '0:', ''.bencode
  end

  def test_single_char
    ('a'..'z').each do |char|
      assert_equal '1:' + char, char.bencode
    end
  end

  def test_single_line
    assert_equal '2:ab', 'ab'.bencode
    assert_equal '3:abc', 'abc'.bencode
    assert_equal '4:abcd', 'abcd'.bencode
  end

  def test_whitespace
    [" ", "\t", "\n", "\r"].each do |char|
      assert_equal '1:' + char, char.bencode
      assert_equal '2:' + char * 2, (char * 2).bencode
    end
  end

  def test_multi_line
    assert_equal "3:a\nb", "a\nb".bencode
  end
end
