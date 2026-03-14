require "rails_helper"

RSpec.describe NightlyTripSummaryJob, type: :job do
  describe "#perform" do
    before do
      create(:trip, rating: 5)
      create(:trip, rating: 4)
      create(:trip, rating: 5)
    end

    it "logs the summary of trips grouped by rating" do
      log_output = StringIO.new
      allow(Rails.logger).to receive(:info) { |msg| log_output.puts(msg) }

      described_class.perform_now

      log_output.rewind
      logs = log_output.string

      expect(logs).to include("=== Nightly Trip Ratings Summary ===")
      expect(logs).to include("Rating 5: 2 trip(s)")
      expect(logs).to include("Rating 4: 1 trip(s)")
    end
  end
end
