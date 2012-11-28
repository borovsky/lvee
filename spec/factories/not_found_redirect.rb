require 'factory_girl'

FactoryGirl.define do
  factory :not_found_redirect do
    path "not_found"
    target "new/target/page"
  end
end

