module Zuora
  module Api
    module V1
      class Contact < Base
        #
        # Create Contact
        #
        # @param [Hash] params params
        #
        # 例)
        # Api::V1::Contact.create({})
        #
        def self.create(params)
          request(:post, "/v1/object/contact", params.to_json)
        end

        #
        # Update Contact
        #
        # @param [String] id objectId
        # @param [Hash] params params
        #
        # 例)
        # Api::V1::Contact.update('8ad0965d7d134b0e017d20376abd0d98', {})
        #
        def self.update(id, params)
          request(:put, "/v1/object/contact/#{id}", params.to_json)
        end

        #
        # Retrieve Contact
        #
        # @param [String] id objectId
        #
        # 例)
        # Api::V1::Contact.retrieve("8ad0965d7d134b0e017d20376abd0d98")
        #
        def self.retrieve(id)
          request(:get, "/v1/object/contact/#{id}")
        end
      end
    end
  end
end
