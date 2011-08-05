class RecreateImagesVersions < ActiveRecord::Migration
  def up
    User.all.each do |user|
      if user.avator.url
        if File.exists? user.avator.current_path
          user.avator.recreate_versions!
        else
          user.avator=nil
          user.save
        end
      end
    end
  end

  def down
  end
end
