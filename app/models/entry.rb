class Entry < ActiveRecord::Base
  has_and_belongs_to_many :legislators, -> { uniq }
  has_and_belongs_to_many :keywords, -> { uniq }
  belongs_to :user
  belongs_to :committee
  validate :has_at_least_one_legislator
  validate :is_source_url
  delegate :ad, :to => :ad_session, :allow_nil => true
  default_scope { order(created_at: :desc) }
  validates_presence_of :title, message: '請填寫標題'
  validates_presence_of :content, message: '請填寫內容'
  validates_presence_of :source_url, message: '請填寫來源網址'
  validates_presence_of :source_name, message: '請填寫新聞來源'
  validates_presence_of :date, message: '請填寫新聞日期'
  validates_presence_of :user_id, message: '必須有回報者'
  scope :published, -> { where(published: true) }
  scope :created_in_time_count, ->(date, duration) { where(created_at: (date..(date + duration))).count }
  scope :created_after, -> (date) { where("created_at > ?", date) }

  private

  def has_at_least_one_legislator
    errors.add(:base, '必須加入至少一名立法委員！') if self.legislators.blank?
  end

  def is_source_url
    source_uri = URI.parse(self.source_url)
    begin
      errors.add(:base, '新聞來源網址無法存取') unless HTTParty.get(self.source_url).code == 200
    rescue
      errors.add(:base, '新聞來源網址錯誤')
    end
  end
end
