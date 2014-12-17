class AdSession < ActiveRecord::Base
  belongs_to :ad
  has_many :entries
  has_many :questions
  has_many :videos

  def self.current_ad_session(date)
    where(["date_start <= ? AND ( date_end >= ? OR date_end IS NULL )", date, date ])
  end

end
