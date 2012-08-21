class User < ActiveRecord::Base
  has_secure_password

  has_many :posts, :foreign_key => 'author_id'

  attr_accessible :userid, :email, :password

  validates :email, presence:true, uniqueness:true
  validates :userid, presence:true, uniqueness:true

  ADMIN     = 'admin'
  GOD       = 'god'
  MEMBER    = 'member'
  MINIADMIN = 'miniadmin'
  VIP       = 'vip'
  ROLES     = [GOD,ADMIN,MINIADMIN,VIP,MEMBER]

  class << self
    def role(s); 2**ROLES.index(s.to_s) end
  end
end
