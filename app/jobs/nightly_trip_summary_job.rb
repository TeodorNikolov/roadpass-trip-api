class NightlyTripSummaryJob < ApplicationJob
  queue_as :default

  def perform
    summary = Trip.group(:rating).count

    Rails.logger.info "=== Nightly Trip Ratings Summary ==="
    summary.each do |rating, count|
      Rails.logger.info "Rating #{rating}: #{count} trip(s)"
    end
  end
end
