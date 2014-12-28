FactoryGirl.define do
  factory :legislator do
    sequence(:name)  { |n| "Legislator #{n}" }
    in_office true
    image "515.jpg"

    after :create do |legislator|
      create :election, legislator: legislator
    end
  end
end
