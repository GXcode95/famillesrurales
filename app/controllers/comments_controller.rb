class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = @post.comments.build(comment_params)

    if @comment.save
      redirect_to @post, notice: "Commentaire ajouté avec succès."
    else
      @comments = @post.comments.order(created_at: :asc)
      render "posts/show", status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: "Commentaire supprimé avec succès."
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:author, :content)
  end
end

