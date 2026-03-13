class Event < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  has_many_attached :photos
end
