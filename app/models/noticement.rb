class Noticement < ActiveRecord::Base
  belongs_to :user
  belongs_to :notification

  attr_accessible :notification_id, :user_id

  def content; notification.content end
  def full_date; notification.full_date end
  def notifiable; notification.notifiable end
end
