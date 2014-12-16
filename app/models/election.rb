class Election < ActiveRecord::Base
  belongs_to :ad
  belongs_to :legislator
  belongs_to :party
end
