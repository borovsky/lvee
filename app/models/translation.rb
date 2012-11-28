class Translation < ActiveRecord::Base
  belongs_to :language

  attr_accessible :value

  validates :key, :language_id, presence: true

  validates_uniqueness_of :pluralization_index, scope: [:key, :language_id]

  def full_key
    "#{language_id}.#{key}"
  end

  def self.for_locale(locale)
    where(language_id: locale)
  end

  def self.as_hash(converter = nil, mapper = :hash_key)
    ts = {}
    self.all.each{|t| ts[t.send(mapper)] = converter ? t.send(converter) : t}
    ts
  end

  def self.as_translations
    ts = {}
    self.select('`key`, value, language_id').order('pluralization_index ASC').each do |t|
      v = ts[t.full_key]
      if v
        if v.kind_of? Array
          v << t.value
        else
          ts[t.full_key] = [v, t.value]
        end
      else
        ts[t.full_key] = t.value
      end
    end
    ts
  end

  def hash_key
    [key, pluralization_index]
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
