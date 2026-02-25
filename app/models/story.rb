class Story < ApplicationRecord
  belongs_to :character
  has_many :messages, dependent: :destroy

  validates :setting, presence: true
  validates :title, presence: true
  validates :mood, presence: true
  # cloudinary settings
  has_one_attached :photo # need add to form
end
