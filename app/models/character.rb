class Character < ApplicationRecord
  has_many :stories, dependent: :destroy
  belongs_to :user

  validates :name, presence: true
  # cloudinary settings
  has_one_attached :photo # need add to form
end
