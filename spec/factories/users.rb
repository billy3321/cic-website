FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person_#{n}_#{rand(1000).to_s}" }
    sequence(:email) { |n| "person_#{n}_#{rand(1000).to_s}@example.com"}
    password "P@ssw0rd"
    password_confirmation "P@ssw0rd"
    admin      false

    after :create do |user|
      user.confirmed_at = Time.now
      user.save
    end
  end

  factory :admin, class: User do
    sequence(:name)  { |n| "Admin #{n}" }
    sequence(:email) { |n| "Admin_#{n}_#{rand(1000).to_s}@example.com"}
    password "P@ssw0rd"
    password_confirmation "P@ssw0rd"
    admin      true

    after :create do |admin|
      admin.confirmed_at = Time.now
      admin.save
    end
  end
end