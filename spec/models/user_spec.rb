require "spec_helper"

describe User do
  let(:user) {FactoryGirl.create(:user)}

  it "#factory_creat_success" do
    expect {
      FactoryGirl.create :user
    }.to change { User.count }.by(1)
  end

  it "created_in_time_count work" do
    FactoryGirl.create(:user)
    FactoryGirl.create(:user, created_at: 3.months.ago)
    FactoryGirl.create(:user, created_at: 4.months.ago)

    expect(
      User.created_in_time_count(5.months.ago, 3.months)
    ).to eq(2)
  end

  it "login_from" do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    user3 = FactoryGirl.create(:user)
    user4 = FactoryGirl.create(:user, provider: "facebook")
    user5 = FactoryGirl.create(:user, provider: "facebook")
    user6 = FactoryGirl.create(:user, provider: "google_oauth2")

    expect(
      User.login_from("facebook").count
    ).to eq(2)
    expect(
      User.login_from("google_oauth2").count
    ).to eq(1)
    expect(
      User.login_from("").count
    ).to eq(3)
  end
end
