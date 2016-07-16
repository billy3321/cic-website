FactoryGirl.define do
  factory :incantation do
    sequence(:title)  { |n| "Incantation #{n}" }
    sequence(:word) { |n| "Incantation_#{n} Word"}
    positive true
  end
end
