class CcwCitizenScore < ActiveRecord::Base
  belongs_to :committee
  belongs_to :ad_session
end
