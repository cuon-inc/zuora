require "zuora"
require "webmock"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("ZUORA_ENDPOINT").and_return("https://rest.apisandbox.zuora.com")
    allow(ENV).to receive(:[]).with("ZUORA_CLIENT_ID").and_return("client_id")
    allow(ENV).to receive(:[]).with("ZUORA_CLIENT_SECRED").and_return("client_secret")
  end
end

paths = Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")]
paths.sort.each { |f| require f }
