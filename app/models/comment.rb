class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic:true
  belongs_to :commenter, class_name:'User'

  attr_accessible :content

  validates_presence_of :content, :commentable_id, :commenter_id

  def commenter_image_url(version=nil)
    commenter.image_url(version)
  end
  def commenterid; commenter.userid end
  def full_date; commentable.full_date end
  def notify
    Notification.notify_from_about(commenter,self)
  end

  class << self
    def notify_old
      Comment.all.each do |comment|
        comment.notify
      end
    end
  end
end
