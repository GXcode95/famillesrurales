class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # Inscription désactivée : on garde :registerable en commentaire
  # pour pouvoir le réactiver facilement si besoin.
  devise :database_authenticatable,
  #        :registerable,
         :recoverable, :rememberable, :validatable

  has_many :gallery_photos, dependent: :destroy
end
