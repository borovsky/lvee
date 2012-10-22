class Menu < ActiveRecord::Base
  attr_accessible :parent_id, :path, :position, :title, :enabled

  scope :enabled, where(enabled: true)

  acts_as_list scope: :parent_id

  def self.items(mapper = :as_array)
    items = self.order(:parent_id, :position)
    h = {}
    r = []
    items.each do |i|
      l = i.send(mapper) << []
      if h[i.parent_id]
        h[i.parent_id].last << l
      else
        r << l
      end
      h[i.id] = l
    end
    r
  end

  def as_array
    [title, path]
  end

  def as_object
    [self]
  end
end
