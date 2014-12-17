class Party < ActiveRecord::Base
  has_many :elections
  has_many :legislators, through: :elections
  has_many :ads, -> { uniq }, :through => :elections
end
