require 'rails_helper'

describe CcwLegislatorDatum do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :ccw_legislator_datum
    }.to change { CcwLegislatorDatum.count }.by(1)
  end
end
