# spec/rails_helper.rb
require 'database_cleaner/active_record'
# 1️⃣ Set Rails environment
ENV['RAILS_ENV'] ||= 'test'

# 2️⃣ Use Fakeredis for tests to prevent Sidekiq/Redis errors
if ENV['RAILS_ENV'] == 'test'
  require 'fakeredis/rspec'
  ENV['REDIS_URL'] ||= 'redis://localhost:6379/1'
end

# 3️⃣ Patch frozen eager_load_paths for Ruby 3.4 + Rails 8
module RailsPatch
  def self.apply
    if defined?(Rails) && Rails.respond_to?(:application) && Rails.application.respond_to?(:config)
      Rails.application.config.eager_load_paths = Rails.application.config.eager_load_paths.dup
    end
  end
end
RailsPatch.apply

# 4️⃣ Load Rails environment
require_relative '../config/environment'

# 5️⃣ Prevent running tests in production
abort("The Rails environment is running in production mode!") if Rails.env.production?

# 6️⃣ Load RSpec Rails & helpers
require 'rspec/rails'
require 'factory_bot_rails'
require 'test_prof/recipes/rspec/let_it_be'

# Load Shoulda Matchers
require 'shoulda/matchers'

# Configure Shoulda Matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# 7️⃣ Skip Sidekiq Cron jobs in test
module Sidekiq
  module Cron
    class Job
      def self.clear
        # noop in test
      end
    end
  end
end

# 8️⃣ Ensure database schema is up to date
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

# 9️⃣ Configure RSpec
RSpec.configure do |config|
  # Use transactional fixtures
  config.use_transactional_fixtures = true

  # FactoryBot syntax
  config.include FactoryBot::Syntax::Methods

  # Filter Rails backtraces
  config.filter_rails_from_backtrace!
end

# spec/rails_helper.rb
if ENV['DATABASE_URL'].nil? || ENV['DATABASE_URL'].include?('localhost') || ENV['DATABASE_URL'].include?('db')
  DatabaseCleaner.allow_remote_database_url = true
  DatabaseCleaner.clean_with(:truncation, except: %w[ar_internal_metadata])
else
  puts "Skipping DatabaseCleaner.truncation: remote database detected"
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
