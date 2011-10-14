class Thesis < ActiveRecord::Base
  belongs_to :conference_registration, :inverse_of => :thesis
  belongs_to :author, :class_name => "User"
  
  acts_as_versioned
  set_locking_column("version")
  attr_protected :conference_registration_id

  validates :title, :body, :conference_registration_id, :change_summary, :author_id, :presence => true
  validates :conference_registration_id, :uniqueness => true

  has_many :comments, :class_name => "ThesisComment"

  scope :for_review, where(:ready_for_review => true)

  def for_diff(version, prev_version)
    cur = self
    if(version)
      cur = self.find_version(version)
    else
      cur= self.versions.latest
    end

    prev = prev_version ? Thesis.find_version(self.id, prev_version) : cur.previous
    return cur, prev
  end

  def user
    self.conference_registration.user
  end

  def user_id
    self.conference_registration.user_id
  end

  def self.find_version(id, version)
    Version.where(:thesis_id => id, :version => version).first
  end

  def find_version(version)
    Thesis.find_version(self.id, version)
  end

end
