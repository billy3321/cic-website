class Entry < ActiveRecord::Base
  has_and_belongs_to_many :legislators
  belongs_to :user
  belongs_to :committee
  validate :has_at_least_one_legislator

  private

  def has_at_least_one_legislator
    errors.add(:base, 'must add at least one legislator') if self.legislators.blank?
  end
end
