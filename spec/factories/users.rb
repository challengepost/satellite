FactoryGirl.define do
  sequence(:uid) { |n| n.to_s }

  factory :user do
    name "Bob Loblaw"
    email "bob@example.com"
    uid { generate(:uid) }
    image_url "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50"

    factory :devpost_user do
      provider "devpost"
    end
  end
end
