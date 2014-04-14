require 'i18n/backend/flatten'

class I18nUtils
  class << self
    include I18n::Backend::Flatten

    def create_translation(lang, key, idx, value)
      l = lang.translations.build
      l.key = key
      l.pluralization_index = idx
      l.value = value
      l.save!
    end

    def flatten(hash)
      r = []
      flatten_keys(hash, false) {|k, v| r << [k.to_s, v]}
      r
    end

    def import_translation(lang, key, value)
      pluralization_index = 1
      if value.is_a?(Array)
        value.each_with_index do |v, index|
          create_translation(lang, key, index, v) unless v.nil?
        end
      elsif !value.is_a?(Hash)
        create_translation(lang, key, pluralization_index, value)
      end
    end

    def import_language(def_trans, id, hash, remove_default = true)
      lang = Language.find(id)
      lang.transaction do
        # lang.translations.delete_all
        hash.each do |key, value|
          if Translation.where(key: key).count > 0
            unless remove_default && value == def_trans[key]
              import_translation(lang, key, value)
            else
              puts "  skipping #{key} for #{lang.name}"
            end
          else
            import_translation(lang, key, value)
          end
        end
      end
    end
  end
end
