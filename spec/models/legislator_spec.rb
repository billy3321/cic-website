require "spec_helper"

describe Legislator do
  let(:legislator) {FactoryGirl.create(:legislator)}

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :legislator
    }.to change { Legislator.count }.by(1)
  end
end