class Entry < ActiveRecord::Base
  has_and_belongs_to_many :legislators, -> { uniq }
  has_and_belongs_to_many :keywords, -> { uniq }
  belongs_to :user
  belongs_to :committee
  validate :has_at_least_one_legislator
  delegate :ad, :to => :ad_session, :allow_nil => true
  default_scope { order(created_at: :desc) }
  scope :published, -> { where(published: true) }

  private

  def has_at_least_one_legislator
    errors.add(:base, 'must add at least one legislator') if self.legislators.blank?
  end
end
