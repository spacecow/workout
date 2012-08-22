class Post < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  belongs_to :training_type

  attr_accessible :date, :distance, :duration, :time_of_day, :comment, :training_type_token
  attr_reader :training_type_token

  validates_presence_of :date, :author_id, :training_type

  def authorid; author.userid end

  def training_type_name; training_type && training_type.name end

  def training_type_token=(token)
    self.training_type_id = TrainingType.id_from_token(token)
  end
end
