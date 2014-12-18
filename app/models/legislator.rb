class Legislator < ActiveRecord::Base
  has_many :elections
  has_many :ads, through: :elections
  has_and_belongs_to_many :entries, -> { uniq }
  has_and_belongs_to_many :questions, -> { uniq }
  has_and_belongs_to_many :videos, -> { uniq }

  def party
    self.elections.any? ? self.elections.last.party : Party.where(abbreviation: nil).first
  end
end
