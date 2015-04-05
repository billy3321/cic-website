class AdSession < ActiveRecord::Base
  belongs_to :ad
  has_many :entries
  has_many :questions
  has_many :videos
  has_many :ccw_committee_data
  has_many :ccw_citizen_scores
  has_many :ccw_legislator_data, through: :legislator_committees
  validates_presence_of :name, :ad_id, :date_start
  default_scope { order(date_start: :desc) }
  scope :regulations, -> { where(regular: true) }

  def self.current_ad_session(date)
    where(["date_start <= ? AND ( date_end >= ? OR date_end IS NULL )", date, date ])
  end

end
