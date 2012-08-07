require 'factory_girl'

FactoryGirl.define do
  factory :user do
    country "Belarus"
    city "Minsk"
    occupation "Some"
    projects "None"
    activated_at {2.days.ago}
    password "Test123"
    password_confirmation "Test123"
    login "user"
    first_name "Vasisualy"
    last_name "Lohankin"
    role "none"
    email "user@example.com"

    trait :admin do
      login "admin"
      first_name "Alexander"
      last_name "Borovsky"
      role "admin"
      email "admin@example.com"
    end

    trait :editor do
      login "editor"
      first_name "Alexander"
      last_name "Pushkin"
      role "editor"
      email "admin@example.com"
    end
  end
end

