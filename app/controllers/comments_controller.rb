# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: %i[destroy]
  before_action :authenticate_user!, only: %i[destroy]

  def create
    @comment = @commentable.comments.build(comment_params)

    if @comment.save
      redirect_to commentable_redirect_path, notice: "Commentaire ajouté avec succès."
    else
      if @commentable.is_a?(Post)
        @post = @commentable
        @posts = Post.includes(gallery_photos: [:tags, { image_attachment: :blob }]).order(created_at: :desc)
        render "posts/index", status: :unprocessable_entity
      else
        @event = @commentable
        render "events/show", status: :unprocessable_entity
      end
    end
  end

  def destroy
    @comment.destroy
    redirect_to commentable_redirect_path, notice: "Commentaire supprimé avec succès."
  end

  private

  def set_commentable
    @commentable = if params[:post_id]
      Post.find(params[:post_id])
    elsif params[:event_id]
      Event.find(params[:event_id])
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def commentable_redirect_path
    if @commentable.is_a?(Post)
      posts_path(anchor: "post-#{@commentable.id}")
    else
      @commentable
    end
  end

  def comment_params
    params.require(:comment).permit(:author, :email, :content)
  end
end

