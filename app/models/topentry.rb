class Topentry < ActiveRecord::Base
  belongs_to :day
  belongs_to :user

  attr_accessible :score, :day, :duration
  validates_presence_of :day, :duration, :user, :score

  class << self
    def first_date
      return 0 if first.nil?
      (first.day.date.to_time + 9.hours).to_i * 1000
    end

    def generate_total_missing_entries(days, date = Date.today.full)
      #return if Post.count == 0
      User.all.each do |user|
        newdate = Date.parse(date)
        while generate_missing_entries(days, user, newdate.full)
          newdate -= 1.day
        end
      end
    end

    def generate_missing_entries(days, user, date=Date.today.full)
      posts = Post.user(user)
      return false if posts.first.nil?
      date = Date.parse(date)
      return false if (date - posts.first.date).to_i < days

      score = posts.map(&:duration).sum
      day = Day.find_or_create_by_date(date)
      entry = Topentry.find_or_create_by_day_id_and_user_id_and_duration(day.id, user.id, days)
      entry.update_attributes(score:score, duration:days)
    end
  end
end
