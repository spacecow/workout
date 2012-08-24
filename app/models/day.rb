class Day < ActiveRecord::Base
  has_many :posts

  attr_accessible :date
end
