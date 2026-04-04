# frozen_string_literal: true

class GalleryPhotosController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]

  def index
    scope = GalleryPhoto.includes(:user, :tags, image_attachment: :blob).order(created_at: :desc)
    if params[:tag_id].present?
      scope = scope.joins(:tags).where(tags: { id: params[:tag_id] }).distinct
    end
    @filter_tags = Tag.where(id: GalleryPhotoTag.select(:tag_id)).order(:name)
    @selected_tag_id = params[:tag_id].presence
    @pagy, @gallery_photos = pagy(scope, limit: 20)
  end

  def new
    @gallery_photo = GalleryPhoto.new
  end

  def create
    permitted = gallery_photo_params
    @gallery_photo = GalleryPhoto.new
    @gallery_photo.tag_list = permitted[:tag_list]
    tag_list = @gallery_photo.tag_list.to_s

    files = permitted[:images]
    files = Array(files).compact.reject { |f| f.blank? || (f.respond_to?(:size) && f.size.to_i.zero?) }

    if files.empty?
      @gallery_photo.errors.add(:images, "Veuillez sélectionner au moins une image.")
      render :new, status: :unprocessable_entity
      return
    end

    failed_photo = nil
    GalleryPhoto.transaction do
      files.each do |file|
        photo = current_user.gallery_photos.build
        photo.image.attach(file)
        if photo.save
          photo.assign_tags_from_string(tag_list)
        else
          failed_photo = photo
          raise ActiveRecord::Rollback
        end
      end
    end

    if failed_photo
      failed_photo.errors.each do |error|
        attr = error.attribute == :image ? :images : error.attribute
        @gallery_photo.errors.add(attr, error.message)
      end
      render :new, status: :unprocessable_entity
    else
      count = files.size
      notice = count == 1 ? "Photo ajoutée à la galerie." : "#{count} photos ajoutées à la galerie."
      redirect_to gallery_photos_path, notice: notice
    end
  end

  def destroy
    @gallery_photo = GalleryPhoto.find(params[:id])
    @gallery_photo.destroy
    redirect_to gallery_photos_path, notice: "Photo supprimée."
  end

  private

  def gallery_photo_params
    params.require(:gallery_photo).permit(:tag_list, images: [])
  end
end
