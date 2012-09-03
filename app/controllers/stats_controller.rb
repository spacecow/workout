class StatsController < ApplicationController
  def charts
    @selected = :charts
    @topentries = Topentry.order('days.date').includes(:day).group_by{|e| e.user.userid}
  end

  def toplists
    @selected = :toplists
  end
end
