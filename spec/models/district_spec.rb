require 'rails_helper'

describe District do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :district
    }.to change { District.count }.by(1)
  end
end
