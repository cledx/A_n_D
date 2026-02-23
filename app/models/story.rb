class Story < ApplicationRecord
  belongs_to :character
  has_many :messages, dependent: :destroy

  validates :setting, presence: true
  validates :title, presence: true
  validates :mood, presence: true
end
