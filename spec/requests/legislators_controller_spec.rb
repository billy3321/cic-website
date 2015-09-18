require "rails_helper"

describe "Legislator" do

  let(:legislator) { FactoryGirl.create(:legislator) }
  let(:ad_session) { FactoryGirl.create(:ad_session) }
  let(:committee_yc) { FactoryGirl.create(:committee_yc) }
  let(:committee_sc) { FactoryGirl.create(:committee_sc) }
  let(:legislator_committee_yc) { FactoryGirl.create(:legislator_committee, legislator: legislator, committee: committee_yc, ad_session: ad_session) }
  let(:legislator_committee_sc) { FactoryGirl.create(:legislator_committee, legislator: legislator, ad_session: ad_session, committee: committee_sc) }
  let(:ccw_committee_datum_yc) { FactoryGirl.create(:ccw_committee_datum, committee: committee_yc, ad_session: ad_session) }
  let(:ccw_committee_datum_sc) { FactoryGirl.create(:ccw_committee_datum, ad_session: ad_session, committee: committee_sc) }
  let(:ccw_legislator_datum_yc) { FactoryGirl.create(:ccw_legislator_datum, legislator_committee: legislator_committee_yc ) }
  let(:ccw_legislator_datum_sc) { FactoryGirl.create(:ccw_legislator_datum, legislator_committee: legislator_committee_sc ) }
  let(:ccw_citizen_score) { FactoryGirl.create(:ccw_citizen_score, ad_session: ad_session) }


  describe "#index" do
    it "success" do
      get "/legislators/"
      expect(response).to be_success
    end
  end

  describe "#no_record" do
    it "success" do
      get "/legislators/no_record"
      expect(response).to be_success
    end
  end

  describe "#has_records" do
    it "success" do
      get "/legislators/has_records"
      expect(response).to be_success
    end
  end

  describe "#show" do
    it "no_record success" do
      get "/legislators/#{legislator.id}"
      expect(response).to be_success
    end

    it "has_records success" do
      FactoryGirl.create(:entry, legislators: [legislator])
      FactoryGirl.create(:interpellation_record, legislators: [legislator])
      FactoryGirl.create(:video_news, legislators: [legislator])
      get "/legislators/#{legislator.id}"
      expect(response).to be_success
    end
  end

  describe "#entries" do
    it "no_record success" do
      get "/legislators/#{legislator.id}/entries"
      expect(response).to be_success
    end

    it "has_records success" do
      2.times do
        FactoryGirl.create(:entry, legislators: [legislator])
      end
      get "/legislators/#{legislator.id}/entries"
      expect(response).to be_success
    end
  end

  describe "#interpellations" do
    it "no_record success" do
      get "/legislators/#{legislator.id}/interpellations"
      expect(response).to be_success
    end

    it "has_records success" do
      2.times do
        FactoryGirl.create(:interpellation_record, legislators: [legislator])
      end
      get "/legislators/#{legislator.id}/interpellations"
      expect(response).to be_success
    end
  end

  describe "#videos" do
    it "no_record success" do
      get "/legislators/#{legislator.id}/videos"
      expect(response).to be_success
    end

    it "has_records success" do
      2.times do
        FactoryGirl.create(:video_news, legislators: [legislator])
      end
      get "/legislators/#{legislator.id}/videos"
      expect(response).to be_success
    end
  end

  describe "#ccw" do
    it "success" do
      legislator_committee_yc
      ccw_legislator_datum_sc
      ccw_citizen_score
      get "/legislators/#{legislator.id}/ccw"
      expect(response).to be_success
    end
  end

end