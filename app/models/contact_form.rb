# frozen_string_literal: true

class ContactForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :email, :string
  attribute :subject, :string
  attribute :message, :string

  validates :name, presence: { message: "doit être renseigné" }
  validates :email, presence: { message: "doit être renseigné" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "n'est pas valide" }
  validates :message, presence: { message: "doit être renseigné" }
  validates :subject, presence: { message: "doit être renseigné" }
end
