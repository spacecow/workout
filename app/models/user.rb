class User < ActiveRecord::Base
  has_many :posts

  attr_accessible :userid
end
