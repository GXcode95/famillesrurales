# frozen_string_literal: true

class PostsController < ApplicationController
  include ManageGalleryPhotos

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.includes(gallery_photos: { image_attachment: :blob }).order(created_at: :desc)
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = Post.new(post_params)
    if @post.save
      failed = process_new_gallery_photos_for(
        @post,
        files: post_gallery_params[:gallery_images],
        tag_list: post_gallery_params[:gallery_tag_list]
      )
      if failed
        redirect_to edit_post_path(@post),
                    alert: "Article créé, mais l'ajout de photos a échoué : #{failed.errors.full_messages.to_sentence}"
      else
        redirect_to @post, notice: "Article créé avec succès."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      process_gallery_photos_updates(@post, "post")
      failed = process_new_gallery_photos_for(
        @post,
        files: post_gallery_params[:gallery_images],
        tag_list: post_gallery_params[:gallery_tag_list]
      )
      notice = "Article mis à jour avec succès."
      if failed
        flash[:alert] = "Certaines photos n'ont pas été ajoutées : #{failed.errors.full_messages.to_sentence}"
      end
      redirect_to @post, notice: notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: "Article supprimé avec succès."
  end

  private

  def set_post
    @post = Post.includes(gallery_photos: [:tags, { image_attachment: :blob }]).find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def post_gallery_params
    return {} unless params[:post]

    params.require(:post).permit(:gallery_tag_list, gallery_images: [])
  end
end
