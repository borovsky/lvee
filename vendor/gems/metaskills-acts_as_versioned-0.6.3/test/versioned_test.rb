require 'helper'

class VersionedTest < AAVTestCase
  
  
  test "saves versioned copy" do
    p = Page.create! :title => 'first title', :body => 'first body'
    assert !p.new_record?
    assert_equal 1, p.versions.size
    assert_equal 1, p.version
    assert_instance_of Page.versioned_class, p.versions.first
  end

  test "version has unique created on" do
    p = pages(:welcome)
    p.title = 'update me'
    p.save!
    assert_not_equal p.created_on, p.versions.latest.created_on
  end

  test "saves without revision" do
    p = pages(:welcome)
    old_versions = p.versions.count
    p.save_without_revision
    p.without_revision do
      p.update_attributes :title => 'changed'
    end
    assert_equal old_versions, p.versions.count
  end

  test "rollback with version number" do
    p = pages(:welcome)
    assert_equal 24, p.version
    assert_equal 'Welcome to the weblog', p.title
    assert p.revert_to!(23), "Couldn't revert to 23"
    assert_equal 23, p.version
    assert_equal 'Welcome to the weblg', p.title
  end

  test "versioned class name" do
    assert_equal 'Version', Page.versioned_class_name
    assert_equal 'LockedPageRevision', LockedPage.versioned_class_name
  end

  test "versioned class" do
    assert_equal Page::Version,                  Page.versioned_class
    assert_equal LockedPage::LockedPageRevision, LockedPage.versioned_class
  end

  test "special methods" do
    assert_nothing_raised { pages(:welcome).feeling_good? }
    assert_nothing_raised { pages(:welcome).versions.first.feeling_good? }
    assert_nothing_raised { locked_pages(:welcome).hello_world }
    assert_nothing_raised { locked_pages(:welcome).versions.first.hello_world }
  end
  
  test "version objects are ordered by the version columns" do
    p = pages(:welcome)
    assert_sql(/ORDER BY version ASC/) { p.versions(true) }
    assert_equal [23,24], p.versions.map(&:version)
  end

  test "rollback with version class" do
    p = pages(:welcome)
    assert_equal 24, p.version
    assert_equal 'Welcome to the weblog', p.title
    assert p.revert_to!(p.versions.find_by_version(23)), "Couldn't revert to 23"
    assert_equal 23, p.version
    assert_equal 'Welcome to the weblg', p.title
  end

  test "rollback fails with invalid revision" do
    p = locked_pages(:welcome)
    assert !p.revert_to!(locked_pages(:thinking))
  end

  test "saves versioned copy with options" do
    p = LockedPage.create! :title => 'first title'
    assert !p.new_record?
    assert_equal 1, p.versions.size
    assert_instance_of LockedPage.versioned_class, p.versions.first
  end

  test "rollback with version number with options" do
    p = locked_pages(:welcome)
    assert_equal 'Welcome to the weblog', p.title
    assert_equal 'LockedPage', p.versions.first.version_type
    assert p.revert_to!(p.versions.first.lock_version), "Couldn't revert to 23"
    assert_equal 'Welcome to the weblg', p.title
    assert_equal 'LockedPage', p.versions.first.version_type
  end

  test "rollback with version class with options" do
    p = locked_pages(:welcome)
    assert_equal 'Welcome to the weblog', p.title
    assert_equal 'LockedPage', p.versions.first.version_type
    assert p.revert_to!(p.versions.first), "Couldn't revert to 1"
    assert_equal 'Welcome to the weblg', p.title
    assert_equal 'LockedPage', p.versions.first.version_type
  end

  test "saves versioned copy with sti" do
    p = SpecialLockedPage.create! :title => 'first title'
    assert !p.new_record?
    assert_equal 1, p.versions.size
    assert_instance_of LockedPage.versioned_class, p.versions.first
    assert_equal 'SpecialLockedPage', p.versions.first.version_type
  end

  test "rollback with version number with sti" do
    p = locked_pages(:thinking)
    assert_equal 'So I was thinking', p.title

    assert p.revert_to!(p.versions.first.lock_version), "Couldn't revert to 1"
    assert_equal 'So I was thinking!!!', p.title
    assert_equal 'SpecialLockedPage', p.versions.first.version_type
  end

  test "lock version works with versioning" do
    p = locked_pages(:thinking)
    p2 = LockedPage.find(p.id)
    p.title = 'fresh title'
    p.save
    assert_equal 2, p.versions.size # limit!
    assert_raises(ActiveRecord::StaleObjectError) do
      p2.title = 'stale title'
      p2.save
    end
  end

  test "version if condition" do
    p = Page.create! :title => "title"
    assert_equal 1, p.version
    Page.feeling_good = false
    p.save
    assert_equal 1, p.version
    Page.feeling_good = true
  end

  test "version if condition2" do
    # set new if condition
    Page.class_eval do
      def new_feeling_good() title[0..0] == 'a'; end
      alias_method :old_feeling_good, :feeling_good?
      alias_method :feeling_good?, :new_feeling_good
    end
    p = Page.create! :title => "title"
    assert_equal 1, p.version # version does not increment
    assert_equal 1, p.versions.count
    p.update_attributes(:title => 'new title')
    assert_equal 1, p.version # version does not increment
    assert_equal 1, p.versions.count
    p.update_attributes(:title => 'a title')
    assert_equal 2, p.version
    assert_equal 2, p.versions.count
    # reset original if condition
    Page.class_eval { alias_method :feeling_good?, :old_feeling_good }
  end

  test "version if condition with block" do
    # set new if condition
    old_condition = Page.version_condition
    Page.version_condition = Proc.new { |page| page.title[0..0] == 'b' }
    p = Page.create! :title => "title"
    assert_equal 1, p.version # version does not increment
    assert_equal 1, p.versions.count
    p.update_attributes(:title => 'a title')
    assert_equal 1, p.version # version does not increment
    assert_equal 1, p.versions.count
    p.update_attributes(:title => 'b title')
    assert_equal 2, p.version
    assert_equal 2, p.versions.count
    # reset original if condition
    Page.version_condition = old_condition
  end

  test "version no limit" do
    p = Page.create! :title => "title", :body => 'first body'
    p.save
    p.save
    5.times do |i|
      p.title = "title#{i}"
      p.save
      assert_equal "title#{i}", p.title
      assert_equal (i+2), p.version
    end
  end

  test "version max limit" do
    p = LockedPage.create! :title => "title"
    p.update_attributes(:title => "title1")
    p.update_attributes(:title => "title2")
    5.times do |i|
      p.title = "title#{i}"
      p.save
      assert_equal "title#{i}", p.title
      assert_equal (i+4), p.lock_version
      assert p.versions(true).size <= 2, "locked version can only store 2 versions"
    end
  end

  test "track altered attributes default value" do
    assert !Page.track_altered_attributes
    assert LockedPage.track_altered_attributes
    assert SpecialLockedPage.track_altered_attributes
  end

  test "track altered attributes" do
    p = LockedPage.create! :title => "title"
    assert_equal 1, p.lock_version
    assert_equal 1, p.versions(true).size
    p.body = 'whoa'
    assert !p.save_version?
    p.save
    assert_equal 2, p.lock_version # still increments version because of optimistic locking
    assert_equal 1, p.versions(true).size
    p.title = 'updated title'
    assert p.save_version?
    p.save
    assert_equal 3, p.lock_version
    assert_equal 1, p.versions(true).size # version 1 deleted
    p.title = 'updated title!'
    assert p.save_version?
    p.save
    assert_equal 4, p.lock_version
    assert_equal 2, p.versions(true).size # version 1 deleted
  end

  test "find versions" do
    assert_equal 1, locked_pages(:welcome).versions.find(:all, :conditions => ['title LIKE ?', '%weblog%']).size
  end

  test "find version" do
    assert_equal page_versions(:welcome_1), pages(:welcome).versions.find_by_version(23)
  end

  test "with sequence" do
    assert_equal 'widgets_seq', Widget.versioned_class.sequence_name
    3.times { Widget.create! :name => 'new widget' }
    assert_equal 3, Widget.count
    assert_equal 3, Widget.versioned_class.count
  end

  test "has many through" do
    assert_equal [authors(:caged), authors(:mly)], pages(:welcome).authors
  end

  test "has many through with custom association" do
    assert_equal [authors(:caged), authors(:mly)], pages(:welcome).revisors
  end

  test "referential integrity" do
    pages(:welcome).destroy
    assert_equal 0, Page.count
    assert_equal 2, Page::Version.count
  end

  test "association options" do
    association = Page.reflect_on_association(:versions)
    options = association.options
    association = Widget.reflect_on_association(:versions)
    options = association.options
    assert_equal :nullify, options[:dependent]
    assert_equal 'version desc', options[:order]
    assert_equal 'widget_id', options[:foreign_key]
    widget = Widget.create! :name => 'new widget'
    assert_equal 1, Widget.count
    assert_equal 1, Widget.versioned_class.count
    widget.destroy
    assert_equal 0, Widget.count
    assert_equal 1, Widget::Version.count
  end

  test "versioned records should belong to parent" do
    page = pages(:welcome)
    page_version = page.versions.last
    assert_equal page, page_version.page
  end

  test "unaltered attributes" do
    landmarks(:washington).attributes = landmarks(:washington).attributes.except("id")
    assert !landmarks(:washington).changed?
  end

  test "unchanged string attributes" do
    landmarks(:washington).attributes = landmarks(:washington).attributes.except("id").inject({}) { |params, (key, value)| params.update(key => value.to_s) }
    assert !landmarks(:washington).changed?
  end

  test "should find earliest version" do
    assert_equal page_versions(:welcome_1), pages(:welcome).versions.earliest
  end

  test "should find latest version" do
    assert_equal page_versions(:welcome_2), pages(:welcome).versions.latest
  end

  test "should find previous version" do
    assert_equal page_versions(:welcome_1), page_versions(:welcome_2).previous
    assert_equal page_versions(:welcome_1), pages(:welcome).versions.before(page_versions(:welcome_2))
  end

  test "should find next version" do
    assert_equal page_versions(:welcome_2), page_versions(:welcome_1).next
    assert_equal page_versions(:welcome_2), pages(:welcome).versions.after(page_versions(:welcome_1))
  end

  test "should find version count" do
    assert_equal 2, pages(:welcome).versions.size
  end

  test "if changed creates version if a listed column is changed" do
    landmarks(:washington).name = "Washington"
    assert landmarks(:washington).changed?
    assert landmarks(:washington).altered?
  end

  test "if changed creates version if all listed columns are changed" do
    landmarks(:washington).name = "Washington"
    landmarks(:washington).latitude = 1.0
    landmarks(:washington).longitude = 1.0
    assert landmarks(:washington).changed?
    assert landmarks(:washington).altered?
  end

  test "if changed does not create new version if unlisted column is changed" do
    landmarks(:washington).doesnt_trigger_version = "This should not trigger version"
    assert landmarks(:washington).changed?
    assert !landmarks(:washington).altered?
  end
  
  
end


