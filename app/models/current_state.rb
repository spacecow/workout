class CurrentState < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  accepts_nested_attributes_for :day

  attr_accessible :weight, :note

  validates_presence_of :day_id, :user_id
  validates_presence_of :weight, unless: :note?, message: "can't be blank if note is blank"
  validates_presence_of :note, unless: :weight?, message: "can't be blank if weight is blank"

  def chartdate; (date.to_time + 9.hour).to_i * 1000 end
  def date; day.date end
  def full_date; date.full end
end
