class Topentry < ActiveRecord::Base
  belongs_to :day
  belongs_to :user

  attr_accessible :score, :day, :duration, :category
  validates_presence_of :day, :duration, :user, :score, :category

  def chartdate; (day.date.to_time + 9.hour).to_i * 1000 end
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
      day = Day.find_or_create_by_date(date)
      ['duration','distance'].each do |category|
        score = category == 'duration' ? user.total_min(days, date) : user.total_km(days, date)
        break if score == '-'
        entry = Topentry.find_or_create_by_day_id_and_user_id_and_duration_and_category(day.id, user.id, days, category)
        entry.update_attributes(score:score, duration:days)
      end
    end

    def entries(user)
      where("user_id = ?", user.id)
    end

    def last_entry(user)
      entries(user).sort_by_date.last
    end

    def sort_by_date
      order('days.date').includes(:day)
    end

    def update_entries(days, user, date=Date.today)
      day = Day.find_or_create_by_date(date)
      ['duration','distance'].each do |category|
        score = category == 'duration' ? user.total_min(days, date) : user.total_km(days, date)
        return false if score == '-'
        entry = Topentry.find_or_create_by_day_id_and_user_id_and_duration_and_category(day.id, user.id, days, category)
        entry.update_attributes(score:score, duration:days)
      end
    end

    def update_forward_day_entries(days, users, date=Date.today)
      date = Date.parse(date) if date.instance_of? String
      users.each do |user|
        interval = [date-(days-1).day,date+(days-1).day]
        posts = Post.user(user).interval(*interval)
        p (interval[0]..interval[-1]).to_a.map do |d|
          d
        end
      end
      #  date_counter = date
      #  while (date_counter - date).to_i < days
      #    break if date_counter > Date.today
      #    break unless update_entries(days, user, date_counter)
      #    date_counter += 1.day
      #  end
      #date = Date.parse(date)
      #users.each do |user|
      #  counter = Date.parse(date.full) 
      #  last_entry = last_entry(user)
      #  last_post = Post.last_post(user)
      #  last_entry_date = last_entry.nil? ? Date.parse('2001-1-1') : last_entry.date
      #  last_post_date = last_post.nil? ? Date.parse('2001-1-1') : last_post.date
      #  while (counter - date).to_i < days
      #    break if ([last_post_date,last_entry_date].max - counter).to_i < 0
      #    generate_missing_entries(days, user, counter.full)
      #    counter += 1.day
      #  end
      #end
    end
  end
end
