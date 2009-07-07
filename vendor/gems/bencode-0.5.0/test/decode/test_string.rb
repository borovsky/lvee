
require 'test/unit'
require "#{File.dirname(__FILE__)}/../../lib/bencode.rb"

class BdecodeStringTest < Test::Unit::TestCase
  def test_empty
    assert_equal '', '0:'.bdecode
  end

  def test_single_line
    assert_equal 'foo', '3:foo'.bdecode
  end

  def test_multi_line
    assert_equal "a\nb", "3:a\nb".bdecode
  end

  def test_whitespace
    [" ", "\t", "\n", "\r"].each do |char|
      assert_equal char, "1:#{char}".bdecode
    end
  end
end
