class AdSession < ActiveRecord::Base
  belongs_to :ad
  has_many :entries
  has_many :interpellations
  has_many :videos
  has_many :ccw_committee_data
  has_many :legislator_committees
  has_one :ccw_citizen_score
  has_many :ccw_legislator_data, through: :legislator_committees
  has_many :legislators, through: :legislator_committees
  has_many :committees, through: :legislator_committees
  validates_presence_of :name, :ad_id, :date_start
  default_scope { order(date_start: :asc) }
  scope :regulations, -> { where(regular: true) }
  scope :has_ccw_data, -> {
    includes(:ad)
    .joins(:ccw_committee_data)
    .group("ad_sessions.id")
  }

  def self.current_ad_session(date)
    where(["date_start <= ? AND ( date_end >= ? OR date_end IS NULL )", date, date ])
  end

  def sc_committees
    committees.where(kind: 'sc').distinct
  end
end
