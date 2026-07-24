# frozen_string_literal: true

class AddAttachableToGalleryPhotos < ActiveRecord::Migration[8.2]
  def change
    return if column_exists?(:gallery_photos, :attachable_type)

    add_reference :gallery_photos, :attachable, polymorphic: true
  end
end
