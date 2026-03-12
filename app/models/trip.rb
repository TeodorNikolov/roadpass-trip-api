class Trip < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :image_url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :short_description, :long_description, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }

  scope :search, ->(term) {
    where("LOWER(name) LIKE ?", "%#{term.downcase}%") if term.present?
  }

  scope :min_rating, ->(rating) {
    where("rating >= ?", rating.to_i) if rating.present?
  }

  scope :sorted, ->(sort) {
    case sort
    when "asc"
      order(rating: :asc)
    when "desc"
      order(rating: :desc)
    else
      order(name: :asc)
    end
  }
end
