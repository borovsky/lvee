class Thing < ActiveRecord::Base
  
  attr_accessor :version
  acts_as_versioned
  
  
end
