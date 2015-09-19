require "rails_helper"

describe "Ccw" do
  let(:ad_session) { FactoryGirl.create(:ad_session) }
  let(:committee_yc) { FactoryGirl.create(:committee_yc) }
  let(:committee_sc) { FactoryGirl.create(:committee_sc) }
  let(:legislator_committee_yc) { FactoryGirl.create(:legislator_committee, committee: committee_yc, ad_session: ad_session) }
  let(:legislator_committee_sc) { FactoryGirl.create(:legislator_committee, ad_session: ad_session, committee: committee_sc) }
  let(:ccw_committee_datum_yc) { FactoryGirl.create(:ccw_committee_datum, committee: committee_yc, ad_session: ad_session) }
  let(:ccw_committee_datum_sc) { FactoryGirl.create(:ccw_committee_datum, ad_session: ad_session, committee: committee_sc) }
  let(:ccw_citizen_score) { FactoryGirl.create(:ccw_citizen_score, ad_session: ad_session) }

  describe "#index" do
    it "success" do
      get "/ccws/"
      expect(response).to be_success
    end
  end

  describe "#citizen_score" do
    it "success" do
      legislator_committee_yc
      legislator_committee_sc
      ccw_citizen_score
      get "/ccws/#{ad_session.id}/citizen_score/"
      expect(response).to be_success
    end
  end
end