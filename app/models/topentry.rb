class Topentry < ActiveRecord::Base
  belongs_to :day
  belongs_to :user

  attr_accessible :score, :day, :duration
  validates_presence_of :day, :duration, :user, :score

  class << self
    def generate_total_missing_entries(days, date = Date.today.full)
      return if Post.count == 0
      first_post = Post.order("days.date").includes(:day).first
      date = Date.parse(date)
      while (date - first_post.date).to_i >= days
        User.all.each do |user|
          generate_missing_entries(days, user, date.full)
        end 
        date -= 1.day
      end
    end

    def generate_missing_entries(days, user, date=Date.today.full)
      return if Post.count == 0
      first_post = Post.order("days.date").includes(:day).first
      date = Date.parse(date)
      return if (date - first_post.date).to_i < days
      posts = Post.where("days.date >= ? and days.date <= ?", date-days.days, date).includes(:day)
      score = user.total_min(days, posts, date)
      #user.topentries.create(score:score, duration:days, day:Day.find_or_create_by_date(date))
      entry = Topentry.find_or_create_by_day_id_and_user_id_and_duration(Day.find_or_create_by_date(date).id, user.id, days)
      entry.update_attributes(score:score, duration:days)
    end
  end
end
