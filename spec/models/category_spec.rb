require 'spec_helper'

describe Category do
  let(:category) {FactoryGirl.create(:category)}

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :category
    }.to change { Category.count }.by(1)
  end
end
