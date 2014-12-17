require "spec_helper"

describe Committee do
  let(:committee) {FactoryGirl.create(:committee)}

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :committee
    }.to change { Committee.count }.by(1)
  end
end