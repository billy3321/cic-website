require 'rails_helper'

describe Incantation do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :incantation
    }.to change { Incantation.count }.by(1)
  end
end
