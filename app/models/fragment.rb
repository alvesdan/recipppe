class Fragment < ApplicationRecord
  belongs_to :recipe
  validates :fragment_type, presence: true
  default_scope { order(position: :asc) }
  has_many_attached :images
  scope :with_eager_loaded_images, -> {
    eager_load(images_attachments: :blob)
  }

  COMBINE_OPTIONS = {
    gravity: 'Center',
    resize: '600x350^',
    crop: '600x350+0+0'
  }

  def image_fragment?
    self.fragment_type == "image"
  end

  def image_url_for(image)
    Rails.application.routes.url_helpers
      .rails_representation_url(image.variant(combine_options: COMBINE_OPTIONS),
        only_path: true)
  end

  def as_json(*attrs)
    fragment_hash = super
    if image_fragment?
      fragment_hash[:images] = []
      self.images.each do |image|
        fragment_hash[:images].unshift({
          id: image.id,
          url: image_url_for(image),
          uid: "image-#{image.id}"
        })
      end
    end
    fragment_hash
  end
end
