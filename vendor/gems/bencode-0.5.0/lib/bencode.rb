# = bencode.rb - Bencode Library
# 
# Bencode is a Ruby implementation of the Bencode data serialization 
# format used in the BitTorrent protocol.
#
# == Synopsis
#
# Bencoding (pronounced <i>bee-encode</i>) is a simple protocol, 
# consisting of only 4 value types.
#
# === Integers
#
# An integer is encoded as an _i_ followed by the numeral itself, followed 
# by an _e_. Leading zeros are not allowed. Negative values are prefixed
# with a minus sign.
#
#   42.bencode  #=> "i42e"
#   -2.bencode  #=> "i-2e"
#   0.bencode   #=> "i0e"
#
# === Strings
#   
# Strings are sequences of zero or more bytes. They are encoded as 
# <i>&lt;length&gt;:&lt;contents&gt;</i>, where _length_ is the 
# length of _contents_. _length_ must be non-negative.
#
#   "".bencode     #=> "0:"
#   "foo".bencode  #=> "3:foo"
#
# === Lists
#
# Lists are encoded as _l_ followed by the elements, followed by _e_.
# There is no element seperator.
#
#   [1, 2, 3].bencode  #=> "li1ei2ei3ee"
#
# === Dictionaries
#
# Dictionaries are encoded as _d_ followed by a sequence of key-value 
# pairs, followed by _e_. Each value must be immediately preceded by 
# a key. Keys must be strings, and must appear in lexicographical order.
#
#   {"foo" => 3, "bar" => 1, "baz" => 2}.bencode  
#     #=> "d3:bari1e3:bazi2e3:fooi3ee"
# 
# 
# == Authors
#
# * Daniel Schierbeck
#
# == Contributors
#
# * Daniel Martin
# * Phrogz
# * Julien Pervillé
#
# == Copyright
#
# Bencode is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
# 
# Bencode is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more 
# details.


prefix = File.dirname(__FILE__)

%w[object integer string array hash].each do |type|
  require prefix + '/bencode/encode/' + type
end

%w[decode io encode_error decode_error].each do |file|
  require prefix + '/bencode/' + file
end
