class Committee < ActiveRecord::Base
  has_many :entries
  has_many :interpellations
  has_many :videos
  has_many :legislator_committees
  has_many :ccw_committee_data
  has_many :ccw_citizen_scores
  has_many :legislators, through: :legislator_committees
  has_many :ccw_legislator_data, through: :legislator_committees
  validates_presence_of :name,  message: '請填寫委員會名稱'

  def short_name
    if self.name == "社會福利及衛生環境委員會"
      "社福及衛環"
    elsif self.name == "院會"
      self.name
    else
      self.name.gsub(/委員會/, '')
    end
  end

  def session_legislators(ad_session_id)
    results = legislator_committees.includes(:legislator).where(ad_session_id: ad_session_id).to_a
    results.map! { |l| l.legislator }
  end

  def session_ccw_legislator_data(ad_session_id, order = "attendance")
    if kind == 'sc'
      if order == "attendance"
        results = legislator_committees.includes(:legislator, :ccw_legislator_datum).joins(:ccw_legislator_datum).where(ad_session_id: ad_session_id).order("ccw_legislator_data.sc_attendance desc")
      elsif order == "interpellation"
        results = legislator_committees.includes(:legislator, :ccw_legislator_datum).joins(:ccw_legislator_datum).where(ad_session_id: ad_session_id).order("ccw_legislator_data.sc_interpellation_count desc")
      end
    elsif kind == 'yc'
      results = LegislatorCommittee.includes(:legislator, :ccw_legislator_datum).joins(:ccw_legislator_datum).where(ad_session_id: ad_session_id).order("ccw_legislator_data.yc_attendance desc")
    else
      []
    end
    results.to_a.map! { |l| l.ccw_legislator_datum }
  end
end
