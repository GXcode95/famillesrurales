# frozen_string_literal: true

module ManageGalleryPhotos
  extend ActiveSupport::Concern

  private

  def permitted_gallery_photos_updates(param_key)
    raw = params.dig(param_key, "gallery_photos")
    return {} unless raw.is_a?(ActionController::Parameters) || raw.is_a?(Hash)

    h = raw.respond_to?(:to_unsafe_h) ? raw.to_unsafe_h : raw
    h.transform_values do |v|
      ActionController::Parameters.new(v).permit(:tag_list, :_destroy, :image)
    end
  end

  # Retourne la première GalleryPhoto en erreur, ou nil si tout a réussi.
  def process_new_gallery_photos_for(attachable, files:, tag_list:)
    return unless user_signed_in?

    files = Array(files).compact.reject { |f| f.blank? || (f.respond_to?(:size) && f.size.to_i.zero?) }
    return nil if files.empty?

    tag_list = tag_list.to_s
    failed_photo = nil
    GalleryPhoto.transaction do
      files.each do |file|
        photo = attachable.gallery_photos.build(user: current_user)
        photo.image.attach(file)
        if photo.save
          photo.assign_tags_from_string(tag_list)
        else
          failed_photo = photo
          raise ActiveRecord::Rollback
        end
      end
    end
    failed_photo
  end

  def process_gallery_photos_updates(attachable, param_key)
    return unless user_signed_in?

    permitted_gallery_photos_updates(param_key).each do |id, attrs|
      gp = attachable.gallery_photos.find_by(id: id)
      next unless gp

      if ActiveModel::Type::Boolean.new.cast(attrs[:_destroy]) || attrs[:_destroy].to_s == "1"
        gp.destroy!
        next
      end

      gp.assign_tags_from_string(attrs[:tag_list].to_s) if attrs.key?(:tag_list)

      next if attrs[:image].blank?

      gp.image.attach(attrs[:image])
      gp.save!
    end
  end
end
