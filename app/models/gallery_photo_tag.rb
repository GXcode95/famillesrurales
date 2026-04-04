# frozen_string_literal: true

class GalleryPhotoTag < ApplicationRecord
  belongs_to :gallery_photo
  belongs_to :tag
end
