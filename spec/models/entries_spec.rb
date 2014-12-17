require "spec_helper"

describe Entry do
  let(:entry) {FactoryGirl.create(:entry)}

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :entry
    }.to change { Entry.count }.by(1)
  end
end
