class CurrentStatesController < ApplicationController
  def create
    @current_state = current_user.current_states.build(params[:current_state])
    @current_state.day = get_day
    if @current_state.save
      redirect_to day_path(@current_state.full_date), notice:saved(:current_state)
    else
      render 'days/show', id:get_day
    end
  end

  def update
    @current_state = CurrentState.find(params[:id])
    if @current_state.update_attributes(params[:current_state])
      redirect_to day_path(@current_state.full_date), notice:updated(:current_state) 
    else
      render 'days/show', id:get_day
    end
  end

  private

    def get_day
      @day = Day.find_by_date(session_day)
    end
end
