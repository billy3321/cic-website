FactoryGirl.define do
  factory :district do
    county { FactoryGirl.create(:county) }
    sequence(:name)  { |n| "District #{n}" }
  end
end
