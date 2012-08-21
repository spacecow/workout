class Post < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'

  attr_accessible :date, :distance, :duration, :time_of_day, :comment

  validates_presence_of :date, :author_id

  def authorid; author.userid end
end
