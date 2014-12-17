require 'spec_helper'

describe Party do
  let(:party) {FactoryGirl.create(:party)}

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :party
    }.to change { Party.count }.by(1)
  end
end
