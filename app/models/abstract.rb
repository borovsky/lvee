class Abstract < ActiveRecord::Base
  belongs_to :conference, :inverse_of => :abstracts
  belongs_to :author, :class_name => "User"
  has_and_belongs_to_many :users, :join_table => "users_abstracts", :uniq => true
  has_many :files, :class_name => "AbstractFile"

  acts_as_versioned
  self.locking_column = :version
  attr_protected :conference_registration_id

  validates :title, :summary, :authors, :body, :license,
            :conference_id, :change_summary, :author_id, :presence => true

  has_many :comments, :class_name => "AbstractComment"

  attr_accessible :title, :summary, :body, :license, :change_summary, :authors, :author,
    :ready_for_review

  scope :for_review, where(ready_for_review: true)
  scope :published, where(published: true)

  def for_diff(version, prev_version)
    cur = self
    if(version)
      cur = self.find_version(version)
    else
      cur= self.versions.latest
    end

    prev = prev_version ? Abstract.find_version(self.id, prev_version) : cur.previous
    return cur, prev
  end

  def self.find_version(id, version)
    Version.where(:abstract_id => id, :version => version).first
  end

  def find_version(version)
    Abstract.find_version(self.id, version)
  end

end
