FactoryGirl.define do
  factory :party do
    sequence(:name)  { |n| "Party #{n}" }
    sequence(:image)  { |n| "kmt.gif" }
    sequence(:abbreviation)  { |n| "Pty_#{n}" }
  end
end
