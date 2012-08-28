class ApplicationController < ActionController::Base
  include BasicApplicationController

  protect_from_forgery

  helper_method :pl, :current_user, :mess, :jt

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
end
