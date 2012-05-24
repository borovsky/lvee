#require "action_controller/test_process"

class CreateSponsors < ActiveRecord::Migration
  def self.add_sponsor(name, logo, url, type)
    file = File.join(Rails.root, "public", "images", "logos", logo)

    Sponsor.create!(:name => name,
      :image => Rack::Test::UploadedFile.new(file, nil, true),
      :url => url,
      :sponsor_type => type)
  end

  def self.up
    create_table :sponsors do |t|
      t.string :name
      t.string :url
      t.string :image
      t.string :sponsor_type

      t.timestamps
    end

    add_sponsor("MLUG", "mlug.gif", "http://mlug.linux.by/", "organizer")
    add_sponsor("Sam Solutions", "sam-solutions.gif", "http://sam-solutions.by/", "sponsor")
    add_sponsor("PromWad", "prom-wad.gif", "http://www.promwad.com/", "sponsor")
    add_sponsor("Epam", "epam.gif", "http://epam.com", "sponsor")
    add_sponsor("BLRSoft", "blr-soft.gif", "http://www.abaxia.com/", "sponsor")
    add_sponsor("Alatys", "alatys.gif", "http://www.alatys.com/", "sponsor")
    add_sponsor("Onliner", "onliner.gif", "http://www.onliner.by/", "sponsor")
    add_sponsor("Lans", "lans.png", "http://www.lans.by/", "technical")
    add_sponsor("Network solutions", "web-solutions.gif", "http://www.nestor.minsk.by/sr/", "information")
  end

  def self.down
    drop_table :sponsors
  end
end
