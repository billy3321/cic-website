require "rails_helper"

describe Party do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :party
    }.to change { Party.count }.by(1)
  end

  it 'abbr_name should work' do
    party1 = FactoryGirl.create :party
    party2 = FactoryGirl.create(:party, abbreviation: nil)

    expect(party1.abbr_name).to eq(party1.abbreviation.to_s.downcase)
    expect(party2.abbr_name).to eq("null")
  end
end