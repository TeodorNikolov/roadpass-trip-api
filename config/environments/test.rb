# The test environment is used exclusively to run your application's
# test suite. Remember the test database is wiped and recreated between runs.

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Reloading is not necessary while tests run files.
  config.enable_reloading = false

  # Eager load your entire application in CI or when needed.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with cache-control for performance.
  config.public_file_server.headers = { "cache-control" => "public, max-age=3600" }

  # Show full error reports.
  config.consider_all_requests_local = true

  # Use null store for caching in tests.
  config.cache_store = :null_store

  # -----------------------------
  # ✅ Fix Host Authorization in test
  # Clear host restrictions so tests and RSpec requests always work
  config.hosts.clear
  # -----------------------------

  # Render exception templates for rescuable exceptions and raise for others.
  config.action_dispatch.show_exceptions = :rescuable

  # Disable CSRF protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  # Don't deliver emails to the real world; collect in ActionMailer::Base.deliveries
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { host: "example.com" }

  # Print deprecation notices to stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Raise error when a before_action's only/except options reference missing actions.
  config.action_controller.raise_on_missing_callback_actions = true
end
