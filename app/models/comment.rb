class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic:true
  belongs_to :commenter, class_name:'User'

  attr_accessible :content

  validates_presence_of :content, :commentable_id, :commenter_id

  def commenterid; commenter.userid end
  def full_date; commentable.full_date end
  def notify
    User.where("id <> ?", commenter.id).each do |user|
      Notification.notify_from_about(commenter,self)
    end
  end
end
