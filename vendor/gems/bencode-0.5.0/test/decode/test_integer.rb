
require 'test/unit'
require "#{File.dirname(__FILE__)}/../../lib/bencode.rb"

class BdecodeIntegerTest < Test::Unit::TestCase
  def test_zero
    assert_equal 0, 'i0e'.bdecode
  end
  
  def test_single_digit
    (1..9).each do |digit|
      assert_equal digit, "i#{digit}e".bdecode
    end
  end

  def test_multi_digit
    (1..10).each do |digit|
      assert_equal digit * 10, "i#{digit * 10}e".bdecode
    end
  end

  def test_negative
    (-9..-1).each do |digit|
      assert_equal digit, "i#{digit}e".bdecode
    end
  end

  def test_invalid
    assert_raise(BEncode::DecodeError){ 'i01e'.bdecode }
    assert_raise(BEncode::DecodeError){ 'i-0e'.bdecode }
  end
end
