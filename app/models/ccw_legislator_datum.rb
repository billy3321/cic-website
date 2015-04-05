class CcwLegislatorDatum < ActiveRecord::Base
  belongs_to :legislator_committee
  delegate :legislator, to: :legislator_committee, allow_nil: false
  delegate :committee, to: :legislator_committee, allow_nil: false
  delegate :ad_session, to: :legislator_committee, allow_nil: false
end
