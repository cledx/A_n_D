class Story < ApplicationRecord
  belongs_to :character
  has_many :messages, dependent: :destroy
end
