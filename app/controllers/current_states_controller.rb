class CurrentStatesController < ApplicationController
  before_filter :load_current_state, only: :create
  authorize_resource only: :create 
  load_and_authorize_resource only:[:update,:destroy]

  def create
    @current_state.day = get_day
    if @current_state.save
      redirect_to day_path(@current_state.full_date), notice:saved(:current_state)
    else
      render :new 
    end
  end

  def update
    if @current_state.update_attributes(params[:current_state])
      redirect_to day_path(@current_state.full_date), notice:updated(:current_state) 
    else
      get_day
      render :edit 
    end
  end

  def destroy
    day = @current_state.day
    @current_state.destroy
    redirect_to day_path(day.date.full), notice:deleted(:current_state)
  end

  private

    def get_day
      @day = Day.find_by_date(session_day)
    end

    def load_current_state
      @current_state = current_user.current_states.build(params[:current_state])
    end
end
