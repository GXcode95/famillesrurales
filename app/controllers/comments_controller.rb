# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: %i[destroy]
  before_action :authenticate_user!, only: %i[destroy]

  def create
    @comment = @commentable.comments.build(comment_params)

    if @comment.save
      redirect_to @commentable, notice: "Commentaire ajouté avec succès."
    else
      @commentable.is_a?(Post) ? @post = @commentable : @event = @commentable
      render render_template, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @commentable, notice: "Commentaire supprimé avec succès."
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

  def render_template
    @commentable.is_a?(Post) ? "posts/show" : "events/show"
  end

  def comment_params
    params.require(:comment).permit(:author, :email, :content)
  end
end

