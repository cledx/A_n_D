class Message < ApplicationRecord
  belongs_to :story

  validates :content, presence: true, length: { minimum: 10 }
end
