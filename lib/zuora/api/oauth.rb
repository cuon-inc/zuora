module Zuora
  module Api
    class Oauth
      # @return [OAuth2::AccessToken] access_token
      # @see https://jp.zuora.com/developer/api-reference/#section/Authentication
      def self.access_token
        config = ::Zuora.config
        client = OAuth2::Client.new(
          config.client_id, config.client_secret,
          {
            token_url: "#{config.endpoint}/oauth/token"
          }
        )
        client.client_credentials.get_token
      end
    end
  end
end
