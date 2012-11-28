require 'factory_girl'

FactoryGirl.define do
  factory :conference_registration do
    conference
    user
    quantity 1

    trait :cancelled do
      status {create(:status, :cancelled)}
    end

    trait :new do
      status {create(:status, :new)}
    end

    trait :approved do
      status {create(:status, :approved)}
      transport_from "Some"
      transport_to "Some"
    end

    trait :with_badges do
      ignore do
        number_of_badges 3
      end
      after :create do |cr, evaluator|
        FactoryGirl.create_list :badge, evaluator.number_of_badges, conference_registration: cr
      end
    end
  end
end

