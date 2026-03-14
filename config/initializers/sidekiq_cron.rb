# config/initializers/sidekiq_cron.rb

# Only run in production or staging
return unless Rails.env.production? || Rails.env.staging?

require 'sidekiq/cron/job'

Sidekiq::Cron::Job.create(
  name: 'Nightly Trip Ratings Summary',
  cron: '0 2 * * *',
  class: 'NightlyTripSummaryJob'
)
