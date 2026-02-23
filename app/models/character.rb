class Character < ApplicationRecord
  has_many :stories, dependent: :destroy

  validates :name, presence: true
end
