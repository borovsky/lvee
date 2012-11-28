# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    name "test"
    default false
    file {fixture_file_upload('files/test.zip','application/zip')}
  end
end
