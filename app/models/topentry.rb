class Topentry < ActiveRecord::Base
  belongs_to :day
  belongs_to :user

  attr_accessible :score, :day, :duration
  validates_presence_of :day, :duration, :user, :score

  def chartdate; day.date.to_time.to_i * 1000 end
  def date; day.date end

  class << self
    def generate_total_missing_entries(days, date = Date.today.full)
      User.all.each do |user|
        newdate = Date.parse(date)
        while generate_missing_entries(days, user, newdate.full)
          newdate -= 1.day
        end
      end
    end

    def generate_missing_entries(days, user, date=Date.today.full)
      date = Date.parse(date)
      score = user.total_min(days, date)
      return false if score == '-'
      day = Day.find_or_create_by_date(date)
      entry = Topentry.find_or_create_by_day_id_and_user_id_and_duration(day.id, user.id, days)
      entry.update_attributes(score:score, duration:days)
    end

    def entries(user)
      where("user_id = ?", user.id)
    end

    def last_entry(user)
      entries(user).last
    end

    def generate_forward_day_entries(days, date=Date.today.full)
      date = Date.parse(date)
      User.all.each do |user|
        counter = Date.parse(date.full) 
        last_entry = last_entry(user)
        last_post = Post.last_post(user)
        last_entry_date = last_entry.nil? ? Date.parse('2001-1-1') : last_entry.date
        last_post_date = last_post.nil? ? Date.parse('2001-1-1') : last_post.date
        while (counter - date).to_i < days
          break if ([last_post_date,last_entry_date].max - counter).to_i < 0
          generate_missing_entries(days, user, counter.full)
          counter += 1.day
        end
      end
    end
  end
end
