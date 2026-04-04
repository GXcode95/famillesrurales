class Event < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :gallery_photos, as: :attachable, dependent: :destroy
end
