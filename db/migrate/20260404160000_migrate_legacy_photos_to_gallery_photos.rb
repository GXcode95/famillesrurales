# frozen_string_literal: true

class MigrateLegacyPhotosToGalleryPhotos < ActiveRecord::Migration[8.2]
  def up
    user = User.order(:id).first
    return unless user

    ActiveStorage::Attachment.where(record_type: %w[Post Event], name: "photos").find_each do |att|
      record = att.record
      next unless record

      gp = GalleryPhoto.create!(user_id: user.id, attachable: record)
      gp.image.attach(att.blob)
      att.destroy!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
