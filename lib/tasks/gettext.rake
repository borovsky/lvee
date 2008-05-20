namespace :gt do
  desc "Update pot/po files."
  task :upo do
    require 'gettext/utils'
    GetText.update_pofiles("lvee",
                           Dir.glob("{app,lib,bin}/**/*.{rb,erb,rjs,builder}"),
                           "lvee 0.1.0")
  end

  desc "Create mo-files"
  task :mkmo do
    require 'gettext/utils'
    GetText.create_mofiles(true, "po", "locale")
  end
end
