require 'spec_helper'

describe Election do

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :election, legislator: Legislator.first
    }.to change { Election.count }.by(1)
  end
end
