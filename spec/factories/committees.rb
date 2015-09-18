FactoryGirl.define do
  factory :committee do
    sequence(:name)  { |n| "Committee #{n}" }
  end

  factory :committee_yc, parent: :committee do
    kind 'yc'
  end

  factory :committee_sc, parent: :committee do
    kind 'sc'
  end
end
