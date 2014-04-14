desc "Bootrstaps database and fills it with default data"
task bootstrap: ["db:setup", :import_languages]

