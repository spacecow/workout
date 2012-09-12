module StatsHelper
  def fill_out(a)
    #(a.first.date..a.last.date).map do |date|
    #  state = a.detect{|e| e.date == date}
    #  state && state.weight.to_f || nil
    #end
    #a.map{|e| e.weight.to_f}
    a.map{|e| [e.chartdate, e.weight.to_f]}
  end

  def stats_menu_class(name,selection)
    "class='selected'" if name == selection
  end
end
