class Translation < ActiveRecord::Base
  belongs_to :language

  attr_accessible :value

  def full_key
    "#{language_id}.#{key}"
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
