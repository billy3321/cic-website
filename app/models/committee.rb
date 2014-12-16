class Committee < ActiveRecord::Base
  has_many :entries
  has_many :questions
  has_many :videos
end
