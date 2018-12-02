require "bundler/setup"
require "readable_rails_log"
require "support/time_helpers"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.include TimeHelpers

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
