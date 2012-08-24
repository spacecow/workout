class TrainingTypesController < ApplicationController
  load_and_authorize_resource

  def show
    session[:type] = @training_type.id
    @post = Post.new(:training_type_token => @training_type.id.to_s)
    @training_partners = User.minus(current_user)
  end

  def index
    @training_types = TrainingType.order(:name)
    respond_to do |f|
      f.json {render json:@training_types.tokens(params[:q])}
    end
  end
end
