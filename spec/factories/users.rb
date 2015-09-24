FactoryGirl.define do
  sequence(:uid) { |n| n.to_s }

  factory :user do
    name "Bob Loblaw"
    email "bob@example.com"
    uid { generate(:uid) }

    factory :devpost_user do
      provider "devpost"
    end
  end
end
