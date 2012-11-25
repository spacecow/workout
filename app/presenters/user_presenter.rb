class UserPresenter < BasePresenter
  presents :user

  def cancel_button(month, label)
    h.form_tag h.posts_path(month:month), :method => :get do
      h.submit_tag label, :class => :cancel
    end
  end

  def noticements
    h.minititle('Live Update') +
    h.content_tag(:ul, class:'noticements') do
      h.render user.noticements
    end if user.noticements.present?
  end
end
