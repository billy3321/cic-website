FactoryGirl.define do
  factory :ad_session do
    sequence(:name)  { |n| "AdSession #{n}" }
    sequence(:date_start, 1) { |n| Date.today - ( 6 * ( (1..10).to_a[n % 10] )).months }
    sequence(:date_end, 1) { |n| Date.today - ( 6 * ( (1..10).to_a[n % 10] - 1 )).months }
    ad { FactoryGirl.create(:ad) }
  end
end
