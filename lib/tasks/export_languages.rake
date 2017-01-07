desc "Export languages"
task :export_languages  => :environment do

  languages = Array.new
  Language.select(:name).each do |row|
    languages.push(row.name)
  end

  languages.each do |lang|

    puts "Importing #{lang}..."
    hash = Hash.new

    Translation.where(language_id: "#{lang}").select("`key`").each do |row|

      rows_with_key = Translation.where(language_id: "#{lang}", key: "#{row[:key]}").select("`value`")
      if rows_with_key.count > 1
        value = Array.new
        rows_with_key.each do |val|
          val[:value] = "~" if !val[:value]
          value.push(val[:value])
        end
      else
        value = rows_with_key.first[:value]
      end

      r = row[:key].split(".").reverse.push("#{lang}").inject(value) { |a, n| { n => a } }
      hash = hash.deep_merge(r)
    end

    File.open("./tmp/#{lang}.yml", "w") do |f|
      f.write(hash.to_yaml)
    end
    puts hash.to_yaml

  end

end
