require 'factory_girl'

FactoryGirl.define do
  factory :status do
    trait :new do
      name NEW_STATUS
      mail "New Mail"
      subject "New subject"
    end

    trait :approved do
      name APPROVED_STATUS
      mail "Approved Mail"
      subject "Approved Subject"
    end

    trait :cancelled do
      name CANCELLED_STATUS
      mail "Cancelled mail"
      subject "Cancelled Subject"
    end
  end
end

