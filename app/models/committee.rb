class Committee < ActiveRecord::Base
  has_many :entries
  has_many :interpellations
  has_many :videos
  has_many :legislator_committees
  has_many :ccw_committee_data
  has_many :ccw_citizen_scores
  has_many :ccw_legislator_data, through: :legislator_committees
  validates_presence_of :name,  message: '請填寫委員會名稱'
end
