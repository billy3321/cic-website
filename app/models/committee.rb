class Committee < ActiveRecord::Base
  has_many :entries
  has_many :questions
  has_many :videos
  validates_presence_of :name,  message: '請填寫委員會名稱'
end
