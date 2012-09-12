class CurrentState < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  accepts_nested_attributes_for :day

  attr_accessible :weight

  validates_presence_of :day_id, :weight, :user_id

  def date; day.date end
  def full_date; date.full end
end
