class CurrentStatePresenter < BasePresenter
  presents :current_state

  def delete_button(session_month)
    h.form_tag current_state, id:'delete_current_state', method: :delete do
      h.submit_tag h.t('helpers.submit.delete'), class: :delete
    end if h.can? :destroy, current_state unless current_state.new_record?
  end
end
