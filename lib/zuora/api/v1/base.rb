module Zuora
  module Api
    module V1
      class Base
        def self.oauth_access_token
          @oauth_access_token ||= ::Zuora::Api::Oauth.access_token
          @oauth_access_token = ::Zuora::Api::Oauth.access_token if @oauth_access_token.expired?
          @oauth_access_token
        end

        def self.default_headers
          {
            Authorization: "Bearer #{oauth_access_token.token}",
            "Content-Type": "application/json"
          }
        end

        # TODO: エラー処理
        def self.fail_or_return_response_body(res)
          config.logger.debug(res)
          config.logger.debug(res.status)

          body = JSON.parse(res.body)

          config.logger.debug(body)

          # raise body.to_s unless res.status == 200

          body
        end

        def self.request(method, url, params = {}, headers = {})
          raise ArgumentError, "methodが存在しません" unless %i[get post patch put delete].include?(method)

          headers = headers.merge(default_headers)
          res = Faraday.public_send(method, "#{config.endpoint}#{url}",
                                    params,
                                    headers)
          fail_or_return_response_body(res)
        end

        def self.config
          ::Zuora.config
        end
      end
    end
  end
end
