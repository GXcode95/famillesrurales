class HomeController < ApplicationController
  def index
    @latest_posts = Post.order(created_at: :desc).limit(3)
  end
end
