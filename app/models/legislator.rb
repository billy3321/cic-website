class Legislator < ActiveRecord::Base
  has_many :elections
  has_many :ads, through: :elections
  has_and_belongs_to_many :entries
  has_and_belongs_to_many :questions
  has_and_belongs_to_many :videos

  def party
    self.elections.any? ? self.elections.last.party : nil
  end
end
