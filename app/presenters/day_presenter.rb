class DayPresenter < BasePresenter
  def current_state_form(current_state)
    h.render 'current_states/form', current_state:current_state
  end
end
