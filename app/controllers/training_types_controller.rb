class TrainingTypesController < ApplicationController
  load_and_authorize_resource

  def show
    set_type
    @post = Post.new(:training_type_token => @training_type.id.to_s)
    @post.build_day
    @training_partners = User.minus(current_user)
  end

  def index
    @training_types = TrainingType.order(:name)
    respond_to do |f|
      f.json {render json:@training_types.tokens(params[:q])}
    end
  end

  private
    
    def set_type
      session_type(@training_type.id)
      session_day(nil)
      session_user(nil)
    end
end
