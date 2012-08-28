class Day < ActiveRecord::Base
  has_many :posts

  attr_accessible :date

  validates :date, presence:true, uniqueness:true
end
