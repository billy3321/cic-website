require "spec_helper"

describe Keyword do
  let(:keyword) {FactoryGirl.create(:keyword)}

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :keyword
    }.to change { Keyword.count }.by(1)
  end
end
