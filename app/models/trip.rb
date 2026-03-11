class Trip < ApplicationRecord

  validates :name, :image_url, :short_description, :long_description, presence: true
  validates :rating, presence: true,
                     numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  scope :search, ->(q) { where("LOWER(name) LIKE ?", "%#{q.downcase}%") if q.present? }
  scope :min_rating, ->(r) { where("rating >= ?", r) if r.present? }

end
