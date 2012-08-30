class StatsController < ApplicationController
  def charts
    @topentries = Topentry.order('days.date').includes(:day)
  end
end
