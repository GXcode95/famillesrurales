class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true

  validates :author, presence: { message: "doit être renseigné" }
  validates :content, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
end
