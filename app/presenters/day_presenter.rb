class DayPresenter < BasePresenter
  presents :day

  def current_state_form(current_state)
    h.content_tag :div, class:['current_state', 'new'].join(' ') do
      h.render 'current_states/form', current_state:current_state unless current_state.nil?
    end
  end

  def edit_post(post, training_partners, return_path)
    output = nil
    h.present post do |presenter|
      output = presenter.edit(training_partners, return_path)
    end
    output
  end

  def new_post(post, training_partners, return_path=nil)
    output = nil
    h.present post do |presenter|
      output = presenter.new(training_partners, return_path)
    end
    output
  end

  def posts(title)
    h.content_tag :ul, class:'posts' do
      h.render day.posts, title:title
    end if day.posts.present?
  end
end
