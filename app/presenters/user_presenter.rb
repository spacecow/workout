class UserPresenter < BasePresenter
  presents :user

  def cancel_button(month, label)
    h.form_tag h.posts_path(month:month), :method => :get do
      h.submit_tag label, :class => :cancel
    end
  end

  def noticements(ns=nil)
    h.minititle('Live Update') +
    h.will_paginate(ns) +
    clear_div +
    h.content_tag(:ul, class:'noticements') do
      h.render ns
    end if ns.present?
  end
end
