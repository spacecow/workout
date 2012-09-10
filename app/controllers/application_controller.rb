class ApplicationController < ActionController::Base
  include BasicApplicationController

  protect_from_forgery

  helper_method :pl, :current_user, :mess, :jt, :session_type, :session_day, :session_user, :return_path, :session_month

  before_filter :load_chat

  rescue_from CanCan::AccessDenied do |exception|
    exception.default_message = alertify(:unauthorized_access)
    flash[:alert] = exception.message
    if current_user
      redirect_to welcome_url
    else
      session[:original_url] = request.path  
      redirect_to login_url(month:params[:month], date:params[:date])
    end
  end

  def session_day(*opt)
    if opt.present? 
      session[:day] = opt.first 
    else
      session[:day] 
    end
  end
  def session_month(*opt)
    if opt.present? 
      session[:month] = opt.first 
    else
      session[:month] 
    end
  end
  def session_type(*opt)
    if opt.present? 
      session[:type] = opt.first 
    else
      session[:type] 
    end
  end
  def session_user(*opt)
    if opt.present? 
      session[:user] = opt.first 
    else
      session[:user] 
    end
  end

  def return_path(post)
    if !session_type.nil?
      training_type_path(session_type)
    elsif !session_day.nil?
      day_path(session_day)
    elsif !session_user.nil?
      user_path(session_user)
    elsif !post.date.nil?
      day_path(post.date)
    else
      day_path(Date.today)
    end
  end

  private

    def load_chat
      @comments = Comment.where("updated_at > ?", Time.at(params[:after].to_i + 1))
    end
end
