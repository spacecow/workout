class StatsController < ApplicationController
  def charts
    @topentries = Topentry.order('days.date').includes(:day).group_by{|e| e.user.userid}
  end
end
