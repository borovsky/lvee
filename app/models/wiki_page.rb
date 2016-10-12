class WikiPage < ActiveRecord::Base
  include WikiPageConcern
  belongs_to :user
  self.locking_column = :version
  acts_as_versioned

  validates :body, :user_id, :presence => true
  validates :name, :uniqueness => true, :presence => true
  attr_accessible :name, :body, :parent_id, :version

  def self.order_all
    order("name")
  end

  def self.find_version(id, version)
    Version.where(:wiki_page_id => id, :version => version).first
  end

  def find_version(version)
    WikiPage.find_version(self.id, version)
  end
end
