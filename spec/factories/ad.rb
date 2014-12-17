FactoryGirl.define do
  factory :ad do
    sequence(:name)  { |n| "Ad #{n}" }
    sequence(:vote_date, 1) { |n| Date.today - ( 4 * ( (1..10).to_a[n % 10] )).years }
    sequence(:term_start, 1) { |n| Date.today - ( 4 * ( (1..10).to_a[n % 10] )).years }
    sequence(:term_end, 1) { |n| Date.today - ( 4 * ( (1..10).to_a[n % 10] )).years }
  end
end
