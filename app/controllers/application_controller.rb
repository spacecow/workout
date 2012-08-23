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

    #def set_date
    #  assert_not_nil(session[:date] || params[:date]) if $AVLUSA
    #  session[:date] = params[:date] unless params[:date].nil?
    #  @date = Date.parse(session[:date])
    #end

    #def set_month
    #  assert_not_nil(session[:month] || params[:date]) if $AVLUSA
    #  session[:month] = params[:month] unless params[:month].nil?
    #  @month = Date.parse(session[:month])
    #end
end
