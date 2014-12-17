FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "P@ssw0rd"
    password_confirmation "P@ssw0rd"
  end
end