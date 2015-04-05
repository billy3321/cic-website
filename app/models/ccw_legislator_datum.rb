class CcwLegislatorDatum < ActiveRecord::Base
  belongs_to :legislator_committee
  belongs_to :legislator, through: :legislator_committee
  belongs_to :committee, through: :legislator_committee
  belongs_to :ad_session, through: :legislator_committee
end
