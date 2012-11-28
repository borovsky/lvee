desc "Updates languages"
task :update_languages  => :environment do
  Object.class_eval do
    include LanguageUpdateHelper

    def update_language(lang, def_lang)
      cur_lang = YAML.load_file("#{LOCALE_DIR}/#{lang}.yml")

      store_merged_language(def_lang, cur_lang, lang)
    end
  end
  puts "Updating..."
  languages = %w(be hu pl ru uk sk)

  def_lang = YAML.load_file("#{LOCALE_DIR}/en.yml")

  languages.each { |lang|
    puts "Updating #{lang}..."
    update_language(lang, def_lang)
  }
end
