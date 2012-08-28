class ApplicationController < ActionController::Base
  include BasicApplicationController

  protect_from_forgery

  helper_method :pl, :current_user, :mess, :jt, :session_type, :session_day, :session_user, :return_path

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

  def return_path
    if !session_type.nil?
      training_type_path(session_type)
    elsif !session_day.nil?
      day_path(session_day)
    elsif !session_user.nil?
      user_path(session_user)
    end
  end
end
