class Ad < ActiveRecord::Base
  has_many :elections
  has_many :ad_sessions
  has_many :legislators, through: :elections
  has_many :parties, -> { uniq }, through: :elections
  has_many :entries, through: :ad_sessions
  has_many :questions, through: :ad_sessions
  has_many :videos, through: :ad_sessions
end
