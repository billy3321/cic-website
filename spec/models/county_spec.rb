require 'rails_helper'

describe County do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :county
    }.to change { County.count }.by(1)
  end
end
