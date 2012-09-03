module StatsHelper
  def stats_menu_class(name,selection)
    "class='selected'" if name == selection
  end
end
