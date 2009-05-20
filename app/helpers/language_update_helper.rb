module LanguageUpdateHelper
  def store_merged_language(def_lang, cur_lang, language_name)
    hash = def_lang['en'].deep_merge(cur_lang[language_name])

    new_hash = {language_name => hash}
    to_write = new_hash.ya2yaml
    File.open("#{LOCALE_DIR}/#{language_name}.yml", "w") do |f|
      f.write(to_write)
    end
  end
end
