class Notification < ActiveRecord::Base
  belongs_to :creator, class_name:'User'

  belongs_to :notifiable, polymorphic:true
  has_many :noticements
  has_many :users, through: :noticements

  attr_accessible :content, :type_mask

  validates :notifiable_id, presence:true

  NEW  = 'new'
  EDIT = 'edit'
  TYPES = [NEW, EDIT]

  def full_date; notifiable.full_date end

  class << self
    def notify_from_about(notifier,notifiable)
      note = notifier.owned_notifications.build(type_mask:Notification.type(:new), content:notifiable.content)
      note.notifiable = notifiable
      note.save!
    end
    def type(s) 2**TYPES.index(s.to_s) end
  end
end
