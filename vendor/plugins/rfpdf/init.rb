begin
  require('htmlentities') 
rescue LoadError
  # This gem is not required - just nice to have.
end
require('cgi')
require 'rfpdf'

