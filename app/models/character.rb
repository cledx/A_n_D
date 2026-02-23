class Character < ApplicationRecord
  has_many :stories, dependent: :destroy
end
