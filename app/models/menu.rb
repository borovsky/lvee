class Menu < ActiveRecord::Base
  attr_accessible :parent_id, :path, :position, :title

  def self.items
    items = self.order(:parent_id, :position)
    h = {}
    r = []
    items.each do |i|
      l = [i.title, i.path, []]
      if h[i.parent_id]
        h[i.parent_id].last << l
      else
        h[i.parent_id] = l
        r << l
      end
    end
    r
  end
end
