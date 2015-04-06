class Committee < ActiveRecord::Base
  has_many :entries
  has_many :interpellations
  has_many :videos
  has_many :legislator_committees
  has_many :ccw_committee_data
  has_many :ccw_citizen_scores
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
end
