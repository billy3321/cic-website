require 'rails_helper'

describe CcwCitizenScore do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :ccw_citizen_score
    }.to change { CcwCitizenScore.count }.by(1)
  end
end
