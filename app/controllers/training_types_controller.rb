class TrainingTypesController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def index
    @training_types = TrainingType.order(:name)
    respond_to do |f|
      f.json {render json:@training_types.tokens(params[:q])}
    end
  end
end
