require 'assert'

class SessionsController < ApplicationController
  before_filter :set_month

  def new
  end

  def create
    user = User.find_by_userid(params[:login])
    user = User.find_by_email(params[:login]) if user.nil?
    if user && user.authenticate(params[:password])
      session_userid(user.id)
      flash[:notice] = notify(:logged_in)
      if url = session_original_url
        session_original_url(nil)
        redirect_to url and return
      end
      redirect_to root_url(month:@month)
    else
      flash.now.alert = alertify(:invalid_login_or_password)
      render :new
    end
  end

  def destroy
    session_userid(nil)
    redirect_to root_url(month:@month), notice:notify(:logged_out)
  end

  private

    def set_month
      assert_not_nil(params[:month]) if $AVLUSA
      @month = Date.parse(params[:month])
    end
end
