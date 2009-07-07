
%w[string integer float array hash].each do |str|
  require File.dirname(__FILE__) + "/encode/test_#{str}"
end
