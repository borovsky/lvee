class Translation < ActiveRecord::Base
  belongs_to :language

  attr_accessible :value

  validates :key, :language_id, presence: true

  def full_key
    "#{language_id}.#{key}"
  end

  def self.for_locale(locale)
    where(language_id: locale)
  end

  def self.as_hash(converter = nil, mapper = :key)
    ts = {}
    self.all.each{|t| ts[t.send(mapper)] = converter ? t.send(converter) : t}
    ts
  end

  if table_exists? && columns.find{|c| c.name == "updated_at"}
    def self.changed?
      return true if @last_change.nil?
      @last_change < self.maximum(:updated_at)
    end

    def self.reloaded
      @last_change = self.maximum(:updated_at)
    end
  else
    def self.changed?
      false
    end

    def self.reloaded
    end

  end
end
