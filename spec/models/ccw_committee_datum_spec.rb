require 'rails_helper'

describe CcwCommitteeDatum do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :ccw_committee_datum
    }.to change { CcwCommitteeDatum.count }.by(1)
  end
end
