class Thesis < ActiveRecord::Base
  belongs_to :conference, :inverse_of => :thesises
  belongs_to :author, :class_name => "User"
  has_and_belongs_to_many :users, :join_table => "users_thesises", :uniq => true
  
  acts_as_versioned
  set_locking_column("version")
  attr_protected :conference_registration_id

  validates :title, :abstract, :authors, :body, :conference_id, :change_summary, :author_id, :presence => true

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

  def self.find_version(id, version)
    Version.where(:thesis_id => id, :version => version).first
  end

  def find_version(version)
    Thesis.find_version(self.id, version)
  end

end
