Gem::Specification.new do |s|
  s.name     = "acts_as_versioned"
  s.version  = "0.6.2.1"
  s.date     = "2009-02-08"
  s.summary  = "ActiveRecord plugin for versioning your models."
  s.email    = "ken@metaskills.net"
  s.homepage = "http://github.com/metaskills/acts_as_versioned/"
  s.description = "ActiveRecord plugin for versioning your models."
  s.has_rdoc = true
  s.authors  = ["Rick Olson"]
  s.files    = [
    "CHANGELOG", 
    "MIT-LICENSE", 
    "Rakefile", 
    "README.rdoc", 
    "RUNNING_UNIT_TESTS", 
    "lib/acts_as_versioned.rb" ]
  s.test_files = [
    "test/fixtures/authors.yml",
    "test/fixtures/landmark_versions.yml",
    "test/fixtures/landmarks.yml",
    "test/fixtures/locked_pages_revisions.yml",
    "test/fixtures/locked_pages.yml",
    "test/fixtures/page_versions.yml",
    "test/fixtures/pages.yml",
    "test/fixtures/widgets.yml",
    "test/helper.rb",
    "test/lib/boot.rb",
    "test/lib/database.yml",
    "test/lib/schema.rb",
    "test/migration_test.rb",
    "test/migrations/1_add_versioned_tables.rb",
    "test/models/author.rb",
    "test/models/landmark.rb",
    "test/models/page.rb",
    "test/models/thing.rb",
    "test/models/widget.rb",
    "test/versioned_test.rb" ]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.extra_rdoc_files = ["README.rdoc","CHANGELOG","MIT-LICENSE"]
end

