# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :gallery_photo_tags, dependent: :destroy
  has_many :gallery_photos, through: :gallery_photo_tags

  validates :name, presence: true, uniqueness: true

  def self.normalize(name)
    name.to_s.strip.downcase
  end

  def self.find_or_create_for_gallery!(raw_name)
    n = normalize(raw_name)
    raise ArgumentError, "tag vide" if n.blank?

    find_or_create_by!(name: n)
  end
end
