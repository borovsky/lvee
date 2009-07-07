
require 'test/unit'
require "#{File.dirname(__FILE__)}/../../lib/bencode.rb"

class BencodeFloatTest < Test::Unit::TestCase
  def test_illegal_number
    assert_raise BEncode::EncodeError do
      13.37.bencode
    end
  end
end
