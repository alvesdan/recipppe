class Recipe < ApplicationRecord
  validates :name, presence: true, length: { minimum: 6 }
  has_many :fragments
end
