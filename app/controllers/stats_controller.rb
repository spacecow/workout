class StatsController < ApplicationController
  def charts
    @selected = :charts
    @durations7 = Topentry.where('duration = ? and category = ?', 7, 'duration').order('days.date').includes(:day).group_by{|e| e.user.userid}
    @distances7 = Topentry.where('duration = ? and category = ?', 7, 'distance').order('days.date').includes(:day).group_by{|e| e.user.userid}
    @weights = CurrentState.order('days.date').includes(:day).group_by{|e| e.user.userid}
  end

  def toplists
    @selected = :toplists
  end
end
