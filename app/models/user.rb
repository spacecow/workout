class User < ActiveRecord::Base
  has_secure_password

  has_many :posts, :foreign_key => 'author_id', :after_add => :create_first_post_date, :after_remove => :destroy_first_post_date
  has_many :comments, :foreign_key => 'commenter_id'

  has_many :current_states

  has_many :trainingships
  has_many :partner_posts, through: :trainingships

  has_many :topentries
  has_many :days, through: :topentries

  has_many :owned_notifications, class_name:'Notification', foreign_key:'creator_id'
  has_many :noticements
  has_many :notifications, through: :noticements

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessible :userid, :email, :password, :image, :crop_x, :crop_y, :crop_w, :crop_h
  mount_uploader :image, ImageUploader

  validates :email, presence:true, uniqueness:true
  validates :userid, presence:true, uniqueness:true

  after_update :crop_image

  ADMIN     = 'admin'
  GOD       = 'god'
  MEMBER    = 'member'
  MINIADMIN = 'miniadmin'
  VIP       = 'vip'
  ROLES     = [GOD,ADMIN,MINIADMIN,VIP,MEMBER]

  def crop_image
    image.recreate_versions! if crop_x.present?
  end

  def first_post; Post.first_post(self) end

  def total_posts(days, date=Date.today)
    posts = Post.user(self).order('days.date').includes(:day)
    return '-' if posts.empty?
    return '-' if (date - posts.first.date).to_i < (days-1)
    posts.interval(date-(days-1).days,date)
  end

  def total_km(days, date=Date.today)
    posts = total_posts(days, date)
    return '-' if posts == '-'
    posts.map{|e| e.distance.nil? ? 0 : e.distance}.sum
  end
  def total_min(days, date=Date.today)
    posts = total_posts(days, date)
    return '-' if posts == '-'
    posts.map{|e| e.duration.nil? ? 0 : e.duration*e.intensity}.sum/5
  end
  def total_time(days, date=Date.today)
    min = total_min(days, date)
    min == '-' ? '-' : "#{min} min"
  end
  def total_distance(days, date=Date.today)
    dist = total_km(days, date)
    dist == '-' ? '-' : "#{dist} km"
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

  def create_first_post_date(post)
    update_column(:first_post_date,post.date) if (first_post_date.nil? && post.day) || (post.day && first_post_date > post.date)
  end 

  private

    def destroy_first_post_date(post)
      if first_post_date == post.date
        post = first_post
        if post.nil?
          update_column(:first_post_date, nil)
        else
          update_column(:first_post_date, post.date)
        end
      end
    end
end
