class CreateMenus < ActiveRecord::Migration
MENU_ITEMS = [
  ['menu.main.title', 'main'],
  ['menu.conference.title', 'conference', [
      ['menu.conference.about', 'conference'],
      ['menu.conference.history', 'conference/history'],
      ['menu.conference.press', 'conference/press'],
      ['menu.conference.place', 'conference/place'],
      ['menu.conference.payment', 'conference/payment'],
      ['menu.conference.attribution', 'conference/attribution'],
      ['menu.conference.linux', 'conference/linux'],
      ['menu.conference.statistics', 'statistics'],
    ]],
  ['menu.reports.title', 'reports', [
      ['menu.reports.about', 'reports'],
      ['menu.reports.program', 'reports/program'],
      ['menu.reports.abstract', 'reports/abstract'],
      ['menu.reports.materials_2011', 'reports/materials_lvee_2011'],
      ['menu.reports.materials_2010', 'reports/materials_lvee_2010'],
      ['menu.reports.materials_2009', 'reports/materials_lvee_2009'],
      ['menu.reports.materials_2008', 'reports/materials_lvee_2008'],
      ['menu.reports.materials_2007', 'reports/materials_lvee_2007'],
      ['menu.reports.materials_2006', 'reports/materials_lvee_2006'],
      ['menu.reports.materials_2005', 'reports/materials_lvee_2005'],
    ]],
  ['menu.user.title', 'users/current', [
      ['menu.user.profile', 'users/current'],
      ['menu.user.wiki', 'wiki_pages'],
      ['menu.user.conference_registration', 'conference_registrations/LVEE 2012'],
      ['menu.user.volunteers', 'users/volunteers'],
    ]],
  ['menu.sponsors.title', 'sponsors'],
  ['menu.contacts.title', 'contacts', [
      ['menu.contacts.official', 'contacts/official'],
      ['menu.contacts.organizers', 'contacts/organizers'],
      ['menu.contacts.lug', 'contacts/lug']
    ]]
]

  def up
    create_table :menus do |t|
      t.string :path
      t.string :title
      t.integer :position
      t.integer :parent_id
      t.boolean :enabled

      t.timestamps
    end

    MENU_ITEMS.each_with_index do |i, idx1|
      p = Menu.create!(title: i.first, path: i.second, position: idx1, enabled: true)

      (i.third || []).each_with_index do |j, idx2|
        Menu.create!(title: j.first, path: j.second, parent_id: p.id, position: idx2, enabled: true)
      end
    end
  end

  def down
    drop_table :menus
  end
end
