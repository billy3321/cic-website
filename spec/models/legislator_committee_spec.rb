require 'rails_helper'

describe LegislatorCommittee do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :legislator_committee
    }.to change { LegislatorCommittee.count }.by(1)
  end
end
