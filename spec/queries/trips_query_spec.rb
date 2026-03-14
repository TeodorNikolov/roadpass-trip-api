require 'rails_helper'

RSpec.describe TripsQuery do
  let_it_be(:trip1) { create(:trip, name: "Paris", rating: 5) }
  let_it_be(:trip2) { create(:trip, name: "London", rating: 3) }

  it "filters by search" do
    result = described_class.new(Trip.all, search: "paris").call

    expect(result).to include(trip1)
    expect(result).not_to include(trip2)
  end

  it "filters by rating" do
    result = described_class.new(Trip.all, min_rating: 4).call

    expect(result).to include(trip1)
    expect(result).not_to include(trip2)
  end
end
