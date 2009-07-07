
require 'test/unit'
require "#{File.dirname(__FILE__)}/../../lib/bencode.rb"

class BencodeIntegerTest < Test::Unit::TestCase
  def test_zero
    assert_equal 'i0e', 0.bencode
  end

  def test_single_digit
    (1..9).each do |digit|
      assert_equal "i#{digit}e", digit.bencode
    end
  end

  def test_multi_digit
    (1..10).each do |digit|
      assert_equal "i#{digit * 10}e", (digit * 10).bencode
    end
  end

  def test_negative
    (-9..-1).each do |digit|
      assert_equal "i#{digit}e", digit.bencode
    end
  end
end
