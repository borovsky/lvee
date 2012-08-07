require 'factory_girl'

FactoryGirl.define do
  factory :conference do
    name 'LVEE'

    trait :in_future do
      start_date 5.days.from_now
      finish_date 9.days.from_now
    end

    trait :in_past do
      start_date 9.days.ago
      finish_date 5.days.ago
    end
  end
end

