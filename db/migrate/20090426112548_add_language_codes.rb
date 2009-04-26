class AddLanguageCodes < ActiveRecord::Migration
  LANGUAGE_MAPPING = {
    :be => :bel,
    :en => :eng,
    :hu => :hun,
    :lt => :lit,
    :pl => :pol,
    :ru => :rus,
    :uk => :ukr
  }
  def self.up
    add_column :languages, :code3, :string, :limit => 3
    Language.all.each do |l|
      l.code3 = LANGUAGE_MAPPING[l.name.to_sym].to_s if(LANGUAGE_MAPPING[l.name.to_sym])
      l.code3 = l.name + "?" unless l.code3
      l.save!
    end
  end

  def self.down
    remove_column :languages, :code3
  end
end
