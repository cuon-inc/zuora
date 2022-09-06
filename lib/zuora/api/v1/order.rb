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
        # List orders of an invoice owner
        #
        # @param [String] account_number 請求書所有者のアカウント番号
        # @param [Integer] page ページ番号
        # @param [Integer] page_size ページサイズ
        # @param [String] date_filter_option 日付フィルターオプション(orderDate or updatedDate)
        # @param [String <date>] start_date 開始日
        # @param [String <date>] end_date 終了日
        #
        # 例)
        # Api::V1::Order.list_by_account_number('A00001886', page: 1, page_size: 20)
        # Api::V1::Order.list_by_account_number('A00001886',
        #                                        dateFilterOption: 'orderDate',
        #                                        start_date: '2022-01-01',
        #                                        end_date: '2022-12-31')
        #
        def self.list_by_account_number(account_number, page: 1, page_size: 20, **date_params)
          params = { page: page, pageSize: page_size }
          unless date_params.empty?
            params[:dateFilterOption] = date_params[:date_filter_option]
            params[:startDate] = date_params[:start_date]
            params[:endDate] = date_params[:end_date]
          end
          request(:get, "/v1/orders/invoiceOwner/#{account_number}", params)
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
