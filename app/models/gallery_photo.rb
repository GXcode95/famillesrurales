# frozen_string_literal: true

class GalleryPhoto < ApplicationRecord
  ALLOWED_CONTENT_TYPES = %w[image/jpeg image/png image/gif image/webp].freeze

  attr_accessor :tag_list, :images

  belongs_to :user
  belongs_to :attachable, polymorphic: true, optional: true
  has_one_attached :image
  has_many :gallery_photo_tags, dependent: :destroy
  has_many :tags, through: :gallery_photo_tags

  validates :image, presence: true, on: :create
  validate :image_content_type, if: -> { image.attached? }

  def assign_tags_from_string(str)
    gallery_photo_tags.destroy_all
    return if str.blank?

    str.split(/[,;]/).map(&:strip).reject(&:blank?).uniq.each do |raw|
      tags << Tag.find_or_create_for_gallery!(raw)
    end
  end

  private

  def image_content_type
    return if ALLOWED_CONTENT_TYPES.include?(image.content_type)

    errors.add(:image, :invalid)
  end
end
