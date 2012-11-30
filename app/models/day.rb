class Day < ActiveRecord::Base
  has_many :posts
  has_many :current_states

  attr_accessible :date

  validates :date, presence:true, uniqueness:true

  def full_date; date.full end
end
