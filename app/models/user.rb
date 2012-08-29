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

  #def total_min(days)
  #  posts.where("days.date >= ? and days.date <= ?", Date.today-days.days, Date.today).includes(:day).map(&:duration).sum
  #end
  def total_min(days, posts, date=Date.today)
    minutes = posts.map do |post|
      if post.date >= date-days.days and post.date <= date 
        if post.author == self || post.training_partners.include?(self)
          post.duration
        else
          0
        end
      else
        0
      end
    end
    minutes.empty? ? 0 : minutes.sum
  end
  def total_time(days, posts, date=Date.today)
    "#{total_min(days, posts, date)} min"
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
