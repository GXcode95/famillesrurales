class HomeController < ApplicationController
  def index
    @latest_posts = Post.includes(gallery_photos: { image_attachment: :blob }).order(created_at: :desc).limit(3)
  end
end
