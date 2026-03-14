# spec/spec_helper.rb
require 'rspec/core'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Disable RSpec exposing methods globally
  config.disable_monkey_patching!

  # Expectation syntax
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Mock syntax
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Print the 10 slowest examples
  config.profile_examples = 10

  # Run specs in random order
  config.order = :random
  Kernel.srand config.seed
end
