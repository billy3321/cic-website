class LegislatorCommittee < ActiveRecord::Base
  belongs_to :legislator
  belongs_to :committee
  belongs_to :ad_session
  has_one :ccw_legislator_datum

end
