class Entry < ActiveRecord::Base
  has_and_belongs_to_many :legislators
  belongs_to :user
  belongs_to :committee
end
