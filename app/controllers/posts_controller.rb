require 'assert'

class PostsController < ApplicationController
  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.today
    @posts = Post.all
  end

  def detail
    assert_not_nil(params[:date]) if $AVLUSA
    @date = Date.parse(params[:date])
  end
end
