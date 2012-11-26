class Noticement < ActiveRecord::Base
  belongs_to :user
  belongs_to :notification

  attr_accessible :notification_id, :user_id

  validates :notification, presence:true
  validates :user, presence:true

  def content; notification.content end
  def creator; notification.creator end
  def creator_image_url(version=nil); creator.image_url(version) end
  def creatorid; notification.creatorid end
  def full_date; notification.full_date end
  def info; notification.info end
  def klass; "noticement #{unread ? 'unread' : 'read'}" end
  def notifiable; notification.notifiable end
  def userid; user.userid end
end
