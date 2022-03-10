module Zuora
  class << self
    require "forwardable"
    extend Forwardable

    def_delegators :@config, :endpoint, :endpoint=
    def_delegators :@config, :client_id, :client_id=
    def_delegators :@config, :client_secret, :client_secret=
    def_delegators :@config, :logger, :logger=

    def config
      @config ||= Configuration.new do |config|
        config.endpoint = ENV["ZUORA_ENDPOINT"]
        config.client_id = ENV["ZUORA_CLIENT_ID"]
        config.client_secret = ENV["ZUORA_CLIENT_SECRET"]
        config.logger = begin
          require "logger"
          ::Logger.new($stdout)
        end
      end
    end

    def configure
      yield config
    end
  end

  class Configuration
    attr_accessor :endpoint, :client_id, :client_secret, :logger

    def initialize
      yield(self) if block_given?
    end
  end
end
