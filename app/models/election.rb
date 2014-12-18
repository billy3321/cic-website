class Election < ActiveRecord::Base
  belongs_to :ad
  belongs_to :legislator
  belongs_to :party

  scope :ordered_by_vote_date, -> { joins(:ad).order('ads.vote_date') }
end
