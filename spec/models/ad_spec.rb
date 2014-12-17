require 'spec_helper'

describe Ad do
  let(:ad) {FactoryGirl.create(:ad)}

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :ad
    }.to change { Ad.count }.by(1)
  end
end
