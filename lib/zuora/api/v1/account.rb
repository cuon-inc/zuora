module Zuora
  module Api
    module V1
      class Account < Base
        #
        # Create Account
        #
        # @param [Hash] params params
        #
        # 例)
        # Api::V1::Account.create({})
        #
        def self.create(params)
          request(:post, "/v1/accounts", params.to_json)
        end

        #
        # Update Account
        #
        # @param [String] id AccountId
        # @param [Hash] params params
        #
        # 例)
        # Api::V1::Account.update('8ad09b7a7d125dbd017d1262ae280003', {})
        #
        def self.update(id, params)
          request(:put, "/v1/accounts/#{id}", params.to_json)
        end

        #
        # Retrieve Account
        #
        # @param [String] id AccountId
        #
        # 例)
        # Api::V1::Account.retrieve("8ad09b7a7d125dbd017d1262ae280003")
        #
        def self.retrieve(id)
          request(:get, "/v1/accounts/#{id}")
        end
      end
    end
  end
end
