
%w[string integer list dictionary invalid].each do |str|
  require File.dirname(__FILE__) + "/decode/test_#{str}"
end
