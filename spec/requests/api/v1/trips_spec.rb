require 'rails_helper'

RSpec.describe "Trips API", type: :request do
  describe "GET /api/v1/trips" do
    let!(:trips) { create_list(:trip, 3) }

    it "returns trips" do
      get "/api/v1/trips"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["data"].length).to eq(3)
    end
  end

  describe "GET /api/v1/trips/:id" do
    let(:trip) { create(:trip) }

    it "returns the trip" do
      get "/api/v1/trips/#{trip.id}"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["data"]["id"]).to eq(trip.id.to_s)
    end
  end

  describe "POST /api/v1/trips" do
    let(:valid_params) do
      {
        trip: {
          name: "New Trip",
          image_url: "https://example.com/image.jpg",
          short_description: "Short",
          long_description: "Long description",
          rating: 4
        }
      }
    end

    it "creates a trip" do
      expect {
        post "/api/v1/trips", params: valid_params
      }.to change(Trip, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "returns validation errors" do
      post "/api/v1/trips", params: { trip: { name: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
