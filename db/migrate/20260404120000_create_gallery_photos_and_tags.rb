# frozen_string_literal: true

class CreateGalleryPhotosAndTags < ActiveRecord::Migration[8.2]
  def change
    create_table :tags, if_not_exists: true do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :tags, :name, unique: true, if_not_exists: true

    drop_table :gallery_photo_tags, if_exists: true
    drop_table :gallery_photos, if_exists: true

    create_table :gallery_photos do |t|
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    create_table :gallery_photo_tags do |t|
      t.references :gallery_photo, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end
    add_index :gallery_photo_tags, %i[gallery_photo_id tag_id],
              unique: true,
              name: "index_gallery_photo_tags_unique"
  end
end
