class Recipe < ApplicationRecord
  validates :name, presence: true
  has_many :fragments
end
