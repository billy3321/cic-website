require "rails_helper"

describe Committee do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :committee
    }.to change { Committee.count }.by(1)
  end

  it "#short_name work" do
    committee = FactoryGirl.create :committee, name: "社會福利及衛生環境委員會"
    expect(committee.short_name).to eq("社福及衛環")
    committee = FactoryGirl.create :committee, name: "院會"
    expect(committee.short_name).to eq("院會")
    committee = FactoryGirl.create :committee, name: "內政委員會"
    expect(committee.short_name).to eq("內政")
  end
end