require 'spec_helper'

describe AdSession do
  let(:ad_session) {FactoryGirl.create(:ad_session)}

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :ad_session
    }.to change { AdSession.count }.by(1)
  end
end
