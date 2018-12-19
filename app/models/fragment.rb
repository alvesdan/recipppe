class Fragment < ApplicationRecord
  belongs_to :recipe
  has_one :title, class_name: "Recipe::Title"
  validates :fragment_type, presence: true
end
