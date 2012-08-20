require 'assert'

class PostsController < ApplicationController
  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.today
  end

  def detail
    assert_not_nil(params[:date]) if $AVLUSA
    @date = Date.parse(params[:date])
  end
end
