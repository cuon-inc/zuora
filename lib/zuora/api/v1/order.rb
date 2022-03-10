module Zuora
  module Api
    module V1
      class Order < Base
        #
        # List Order
        #
        # @param [Integer] page ページ番号
        # @param [Integer] page_size ページサイズ
        #
        # 例)
        # Api::V1::Order.list(page: 1, page_size: 20)
        #
        def self.list(page: 1, page_size: 20)
          request(:get, "/v1/orders", { page: page, pageSize: page_size })
        end

        #
        # Retrieve Order
        #
        # @param [String] order_number 注文番号
        #
        # 例)
        # Api::V1::Order.retrieve("OM-00002")
        #
        def self.retrieve(order_number)
          request(:get, "/v1/orders/#{order_number}")
        end

        #
        # Create Order
        #
        # @param [String] params paramsJSON文字列
        #
        # 例)
        # params = {
        #            "description": "This is a description for the Order.",
        #            "existingAccountNumber": "A00000383",
        #            "orderDate": "2017-01-01",
        #            "subscriptions": [
        #              {
        #                "orderActions": [
        #                  "createSubscription": {
        #                      "terms":{
        #                        "initialTerm":{
        #                          "termType":"EVERGREEN"
        #                        }
        #                      }
        #                  },
        #                  "type": "CreateSubscription"
        #                ]
        #              }
        #            ]
        #          }
        # Api::V1::Order.create(params)
        #
        def self.create(params)
          request(:post, "/v1/orders", params.to_json)
        end

        #
        # Delete Order
        #
        # @param [String] order_number 注文番号
        #
        # 例)
        # Api::V1::Order.delete("O-00000853")
        #
        def self.delete(order_number)
          request(:delete, "/v1/orders/#{order_number}")
        end
      end
    end
  end
end
