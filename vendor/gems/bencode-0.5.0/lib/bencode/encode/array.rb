
class Array
  #
  # Bencodes the Array object. Bencoded arrays are represented as
  # +lxe+, where +x+ is zero or more bencoded objects.
  #
  #   [1, "foo"].bencode   #=> "li1e3:fooe"
  #
  def bencode
    begin
      "l#{map{|obj| obj.bencode }.join('')}e"
    rescue BEncode::EncodeError
      raise BEncode::EncodeError, "array items must be bencodable"
    # TODO: This is probably a bad idea...
    rescue SystemStackError
      raise BEncode::EncodeError, "cannot encode recursive array"
    end
  end
end
