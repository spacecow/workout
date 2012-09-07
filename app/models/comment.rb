class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic:true
  belongs_to :commenter, class_name:'User'

  attr_accessible :content

  validates_presence_of :content, :commentable_id, :commenter_id

  def commenterid; commenter.userid end
end
