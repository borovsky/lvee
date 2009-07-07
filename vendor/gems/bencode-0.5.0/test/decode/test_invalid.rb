
require 'test/unit'
require "#{File.dirname(__FILE__)}/../../lib/bencode.rb"

class BdecodeInvalidTest < Test::Unit::TestCase
  errors = {:empty_string => '',
            :space_string => ' ',
            :unencoded_string => 'foobar',
            :multiple_top_items => 'i1ei2e',
            :string_length => '4:foo'}

  errors.each do |error, data|
    define_method("test_#{error}") do
      assert_raise(BEncode::DecodeError){ data.bdecode }
    end
  end
end
