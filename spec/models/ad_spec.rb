require 'spec_helper'

describe Ad do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :ad
    }.to change { Ad.count }.by(1)
  end

  it "should order by vote_date asc" do
    ad1 = FactoryGirl.create(:ad, vote_date: Time.now)
    ad2 = FactoryGirl.create(:ad, vote_date: 1.year.ago)
    ad3 = FactoryGirl.create(:ad, vote_date: 2.years.ago)

    expect(Ad.all).to eq([ad3, ad2, ad1])
  end
end
