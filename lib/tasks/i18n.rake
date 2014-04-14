require 'i18n_utils'

desc "Import languages"
task :import_languages  => :environment do
  puts "Importing en..."
  def_trans = YAML.load(IO.read("#{LOCALE_DIR}/en.yml"))
  def_trans.each do |k, v|
    def_trans = Hash[I18nUtils.flatten(v)]
    I18nUtils.import_language(def_trans, k, def_trans, false)
  end

  languages = %w(be hu pl ru uk sk)

  languages.each do |lang|
    puts "Importing #{lang}..."
    trans = YAML.load(IO.read("#{LOCALE_DIR}/#{lang}.yml"))
    trans.each do |l, t|
      t = I18nUtils.flatten(t)
      I18nUtils.import_language(def_trans, l, t)
    end
  end
end
