require "rails_helper"

describe Keyword do
  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :keyword
    }.to change { Keyword.count }.by(1)
  end
end
