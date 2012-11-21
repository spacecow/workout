class CurrentStatePresenter < BasePresenter
  presents :current_state

  def cancel_button
    h.form_tag h.day_path(current_state.full_date), id:'cancel_current_state', :method => :get do
      h.submit_tag h.t('helpers.submit.cancel'), class: :cancel
    end if current_state.errors.present?
  end

  def delete_button
    h.form_tag current_state, id:'delete_current_state', method: :delete do
      h.submit_tag h.t('helpers.submit.delete'), class: :delete
    end if h.can? :destroy, current_state unless current_state.new_record?
  end

  
  def form
    h.render 'current_states/form', current_state:current_state
  end
end
