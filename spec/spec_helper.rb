require "bundler/setup"
require "heimdall"
require "pry"
require "factory_girl"

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    stub_const("Lob::Client", FakeLob)
  end

  config.include FactoryGirl::Syntax::Methods
end
