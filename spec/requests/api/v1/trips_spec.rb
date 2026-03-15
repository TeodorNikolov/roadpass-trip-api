# spec/requests/api/v1/trips_spec.rb
require "rails_helper"

RSpec.describe "Trips API", type: :request do
  let!(:trip1) do
    Trip.create!(
      name: "Beach Paradise",
      image_url: "https://example.com/beach.jpg",
      short_description: "Sunny beach",
      long_description: "A beautiful sunny beach for vacation",
      rating: 5
    )
  end

  let!(:trip2) do
    Trip.create!(
      name: "Mountain Adventure",
      image_url: "https://example.com/mountain.jpg",
      short_description: "High mountain",
      long_description: "Exciting mountain hiking experience",
      rating: 4
    )
  end

  describe "GET /api/v1/trips" do
    it "returns all trips" do
      get "/api/v1/trips"
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      data = json["data"] # TripListSerializer output
      expect(data.size).to eq(2)
      expect(data.map { |t| t["name"] }).to include("Beach Paradise", "Mountain Adventure")
    end

    it "filters trips by search term" do
      get "/api/v1/trips", params: { search: "Beach" }

      json = JSON.parse(response.body)
      data = json["data"]
      expect(data.size).to eq(1)
      expect(data.first["name"]).to eq("Beach Paradise")
    end

    it "filters trips by min_rating" do
      get "/api/v1/trips", params: { min_rating: 5 }

      json = JSON.parse(response.body)
      data = json["data"]
      expect(data.size).to eq(1)
      expect(data.first["name"]).to eq("Beach Paradise")
    end

    it "sorts trips by rating descending" do
      get "/api/v1/trips", params: { sort: "desc" }

      json = JSON.parse(response.body)
      data = json["data"]
      expect(data.first["rating"]).to eq(5)
      expect(data.last["rating"]).to eq(4)
    end
  end

  describe "GET /api/v1/trips/:id" do
    it "returns a single trip" do
      get "/api/v1/trips/#{trip1.id}"
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      trip_json = json["data"]["attributes"] # JSONAPI::Serializer format
      expect(trip_json["name"]).to eq("Beach Paradise")
      expect(trip_json["rating"]).to eq(5)
    end
  end

  describe "POST /api/v1/trips" do
    let(:valid_params) do
      {
        trip: {
          name: "Forest Escape",
          image_url: "https://example.com/forest.jpg",
          short_description: "Quiet forest",
          long_description: "Peaceful escape in the forest",
          rating: 5
        }
      }
    end

    let(:invalid_params) do
      {
        trip: {
          name: "",
          image_url: "invalid-url",
          short_description: "",
          long_description: "",
          rating: 10
        }
      }
    end

    it "creates a trip with valid parameters" do
      expect {
        post "/api/v1/trips", params: valid_params
      }.to change(Trip, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      trip_json = json["data"]["attributes"] # JSONAPI::Serializer format
      expect(trip_json["name"]).to eq("Forest Escape")
      expect(trip_json["rating"]).to eq(5)
    end

    it "returns validation errors with invalid parameters" do
      post "/api/v1/trips", params: invalid_params

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include(
        "Name can't be blank",
        "Image url is invalid",
        "Short description can't be blank",
        "Long description can't be blank",
        "Rating is not included in the list"
      )
    end
  end
end
