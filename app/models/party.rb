class Party < ActiveRecord::Base
  has_many :elections
  has_many :legislators, through: :elections
  has_many :ads, -> { uniq }, through: :elections
  validates_presence_of :name

  def abbr_name
    self.abbreviation? ? self.abbreviation.to_s.downcase : 'null'
  end
end
