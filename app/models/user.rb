class User < ActiveRecord::Base
  has_secure_password

  has_many :posts, :foreign_key => 'author_id'

  has_many :trainingships
  has_many :partner_posts, through: :trainingships

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
    def ids_from_tokens(tokens)
      tokens.gsub!(/<<<(.+?)>>>/){ create!(userid:$1).id}
      tokens.split(",")
    end

    def role(s); 2**ROLES.index(s.to_s) end
  end
end
