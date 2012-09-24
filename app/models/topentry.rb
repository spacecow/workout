require 'assert'

class Topentry < ActiveRecord::Base
  belongs_to :day
  belongs_to :user

  attr_accessible :score, :day, :duration, :category
  validates_presence_of :day, :duration, :user, :score, :category

  def chartdate; (day.date.to_time + 9.hour).to_i * 1000 end
  def date; day.date end
  def full_date; date.full end

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

    def update_forward_day_entries(users, date=Date.today)
      update_forward_day_entry(7, users, date)
      update_forward_day_entry(30, users, date)
    end

    private 

      def update_forward_day_entry(days, users, date=Date.today)
        assert_true(days.instance_of?(Fixnum), "days must be input as Fixnum to update_forward_day_entries")
        date = Date.parse(date) if date.instance_of? String
        users.each do |user|
          start_date = Post.interval_start(days,user,date)
          end_date = Post.interval_end(days,date)
          scores = Post.post_array(user,days,start_date,end_date)
          return if scores.empty?
          (end_date - start_date - days + 2).to_i.times do |i| 
            day = Day.find_or_create_by_date(start_date + i.day + (days-1).day)
            ['duration','distance'].each_with_index do |category,i2|
              score = scores[i..-1].take(days).map{|e| e[i2]}.sum
              entry = Topentry.find_or_create_by_day_id_and_user_id_and_duration_and_category(day.id, user.id, days, category)
              entry.update_attributes(score:score, duration:days)
            end
          end
        end
      end

  end
end
