class Trip < ApplicationRecord
  URL_REGEX = URI::DEFAULT_PARSER.make_regexp(%w[http https])

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :image_url,
            presence: true,
            format: { with: URL_REGEX }

  validates :short_description, :long_description, presence: true

  validates :rating,
            presence: true,
            numericality: { only_integer: true },
            inclusion: { in: 1..5 }

  scope :search, ->(term) {
    term.present? ? where("LOWER(name) LIKE ?", "%#{term.downcase}%") : all
  }

  scope :min_rating, ->(rating) {
    rating.present? ? where("rating >= ?", rating.to_i) : all
  }

  scope :sorted, ->(sort) {
    return order(name: :asc) if sort.blank?

    direction = %w[asc desc].include?(sort) ? sort : "asc"
    order(rating: direction)
  }

  def self.filter(params)
    search(params[:search])
      .min_rating(params[:min_rating])
      .sorted(params[:sort])
  end
end
