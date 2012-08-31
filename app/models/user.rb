class User < ActiveRecord::Base
  has_secure_password

  has_many :posts, :foreign_key => 'author_id'

  has_many :trainingships
  has_many :partner_posts, through: :trainingships

  has_many :topentries
  has_many :days, through: :topentries

  attr_accessible :userid, :email, :password

  validates :email, presence:true, uniqueness:true
  validates :userid, presence:true, uniqueness:true

  ADMIN     = 'admin'
  GOD       = 'god'
  MEMBER    = 'member'
  MINIADMIN = 'miniadmin'
  VIP       = 'vip'
  ROLES     = [GOD,ADMIN,MINIADMIN,VIP,MEMBER]

  def first_post; Post.first_post(self) end

  def total_min(days, date=Date.today)
    posts = Post.user(self).order('days.date').includes(:day)
    return '-' if posts.empty?
    return '-' if (date - posts.first.date).to_i < (days-1)
    posts = posts.interval(date-days.days,date)
    posts.map(&:duration).sum
  end
  def total_time(days, date=Date.today)
    min = total_min(days, date)
    min == '-' ? '-' : "#{min} min"
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
