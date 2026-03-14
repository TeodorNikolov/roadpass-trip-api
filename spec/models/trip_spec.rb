require 'rails_helper'

RSpec.describe Trip, type: :model do
  subject { build(:trip) }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of(:image_url) }
    it { should validate_presence_of(:short_description) }
    it { should validate_presence_of(:long_description) }
    it { should validate_presence_of(:rating) }
    it { should validate_inclusion_of(:rating).in_range(1..5) }
  end

  describe "scopes" do
    let!(:trip1) { create(:trip, name: "Paris Trip", rating: 5) }
    let!(:trip2) { create(:trip, name: "London Trip", rating: 3) }

    it "searches by name" do
      expect(Trip.search("paris")).to include(trip1)
      expect(Trip.search("paris")).not_to include(trip2)
    end

    it "filters by minimum rating" do
      expect(Trip.min_rating(4)).to include(trip1)
      expect(Trip.min_rating(4)).not_to include(trip2)
    end

    it "sorts ascending" do
      expect(Trip.sorted("asc").first).to eq(trip2)
    end

    it "sorts descending" do
      expect(Trip.sorted("desc").first).to eq(trip1)
    end
  end
end
