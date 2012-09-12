class Day < ActiveRecord::Base
  has_many :posts
  has_many :current_states

  attr_accessible :date

  validates :date, presence:true, uniqueness:true
end
