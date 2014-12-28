FactoryGirl.define do
  factory :entry do
    sequence(:title)  { |n| "Entry #{n}" }
    sequence(:content) { |n| "Entry_#{n} Content"}
    user { FactoryGirl.create(:user) }
    legislators {[ FactoryGirl.create(:legislator) ]}
    source_url "http://www.google.com/"
    sequence(:source_name) { |n| "Source Name #{n}"}
    sequence(:date) { |n| Date.today - ( 6 * ( (1..10).to_a[n % 10] )).days }
  end
end
