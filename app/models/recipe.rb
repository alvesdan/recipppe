class Recipe < ApplicationRecord
  validates :name, presence: true, length: { minimum: 6 }
  has_many :fragments
  before_create :generate_urid

  protected

  def generate_urid
    self.urid = SecureRandom.hex(6)
  end
end
