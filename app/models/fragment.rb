class Fragment < ApplicationRecord
  belongs_to :recipe
  validates :fragment_type, presence: true
  default_scope { order(position: :asc) }
end
