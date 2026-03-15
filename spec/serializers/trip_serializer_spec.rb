require 'rails_helper'

RSpec.describe Api::V1::TripSerializer do
  let(:trip) { create(:trip) }

  it "serializes trip attributes" do
    serialized = described_class.new(trip).serializable_hash

    attributes = serialized[:data][:attributes]

    expect(attributes[:name]).to eq(trip.name)
    expect(attributes[:rating]).to eq(trip.rating)
    expect(attributes[:short_description]).to eq(trip.short_description)
  end
end
