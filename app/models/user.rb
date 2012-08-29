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

  def total_min(days)
    posts.where("days.date >= ? and days.date <= ?", Date.today-days.days, Date.today).includes(:day).map(&:duration).sum
  end
  def total_time(days)
    "#{total_min(days)} min"
  end

  class << self
    def ids_from_tokens(tokens)
      tokens.gsub!(/<<<(.+?)>>>/){ create!(userid:$1).id}
      tokens.split(",")
    end

    def minus(user)
      User.where('id <> ?',user.id).map{|e| [e.userid, e.id]}
    end

    def role(s); 2**ROLES.index(s.to_s) end
  end
end
