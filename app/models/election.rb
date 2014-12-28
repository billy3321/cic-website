class Election < ActiveRecord::Base
  belongs_to :ad
  belongs_to :legislator
  belongs_to :party
  validates_presence_of :ad_id, :legislator_id, :party_id, :constituency

  scope :ordered_by_vote_date, -> { joins(:ad).order('ads.vote_date ASC') }
end
