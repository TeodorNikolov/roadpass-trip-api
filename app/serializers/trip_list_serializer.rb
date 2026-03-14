class TripListSerializer

  attr_reader :trip

  def initialize(trip)
    @trip = trip
  end

  def as_json(_options = {})
    attributes
  end

  private

  def attributes
    {
      id: trip.id,
      name: trip.name,
      image_url: trip.image_url,
      short_description: trip.short_description,
      rating: trip.rating
    }
  end
end
