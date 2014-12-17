require 'spec_helper'

describe Election do
  let(:election) {FactoryGirl.create(:election)}

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :election
    }.to change { Election.count }.by(1)
  end
end
