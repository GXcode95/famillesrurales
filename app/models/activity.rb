class Activity < ApplicationRecord
  belongs_to :category, foreign_key: :categories_id
end
