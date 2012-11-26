class Notification < ActiveRecord::Base
  belongs_to :creator, class_name:'User'

  belongs_to :notifiable, polymorphic:true
  has_many :noticements
  has_many :users, through: :noticements

  attr_accessible :content, :type_mask

  validates :notifiable, presence:true
  validates :creator, presence:true

  DELETE = 'delete'
  EDIT = 'edit'
  NEW  = 'new'
  REVIVE = 'revive'
  TYPES = [NEW, EDIT, DELETE, REVIVE]

  def creatorid; creator.userid end
  def full_date; notifiable.full_date end
  def info
    type?(:new) ? content : "#{types.first.capitalize }: #{content}"
  end
  def type?(s); types.include?(s.to_s) end
  def types; TYPES.reject{|r| ((type_mask||0) & 2**TYPES.index(r)).zero? } end

  class << self
    def notify_from_about(notifier,notifiable)
      note = notifier.owned_notifications.build(type_mask:Notification.type(:new), content:notifiable.content)
      note.notifiable = notifiable
      note.save!

      User.where("id <> ?", notifier.id).each do |user|
        user.notifications << note
      end
    end
    def type(s) 2**TYPES.index(s.to_s) end
  end
end
