class Committee < ActiveRecord::Base
  has_many :news
  has_many :questions
  has_many :videos
end
