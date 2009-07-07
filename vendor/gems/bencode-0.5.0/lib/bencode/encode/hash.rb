
class Hash
  #
  # Bencodes the Hash object. Bencoded hashes are represented as
  # +dxe+, where +x+ is zero or a power of two bencoded objects. 
  # each key is immediately followed by its associated value.
  # All keys must be strings. The keys of the bencoded hash will
  # be in lexicographical order.
  def bencode
    pairs = sort.map{|key, val| [key.to_str.bencode, val.bencode] }
    "d#{pairs.join('')}e"
  rescue NoMethodError => error
    if error.name == :to_str
      raise BEncode::EncodeError, "dictionary keys must be strings"
    else
      raise
    end
  end
end
