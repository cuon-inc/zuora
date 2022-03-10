module Zuora
  module Api
    module V1
      class ProductRatePlan < Base
        #
        # List ProductRatePlan
        #
        # @param [String] product_id ProductId
        # @param [Integer] page ページ番号
        # @param [Integer] page_size ページサイズ
        #
        # 例)
        # Api::V1::ProductRatePlan.list_by_product_id("26ed06edf85f6ddc85ccf05a9c633150")
        #
        def self.list_by_product_id(product_id, page: 1, page_size: 20)
          request(:get, "/v1/rateplan/#{product_id}/productRatePlan", { page: page, pageSize: page_size })
        end

        #
        # Retrieve ProductRatePlan
        #
        # @param [String] id ProductRatePlanId
        #
        # 例)
        # Api::V1::ProductRatePlan.retrieve("26ed06ed02bb6b53f7d1443413dec902")
        #
        def self.retrieve(id)
          request(:get, "/v1/object/product-rate-plan/#{id}")
        end
      end
    end
  end
end
