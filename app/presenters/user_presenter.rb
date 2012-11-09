class UserPresenter < BasePresenter
  def cancel_button(month, label)
    h.form_tag h.posts_path(month:month), :method => :get do
      h.submit_tag label, :class => :cancel
    end
  end
end
