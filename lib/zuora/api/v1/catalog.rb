module Zuora
  module Api
    module V1
      class Catalog < Base
        #
        # Retrieve Catalog
        #
        # @param [String] product_id ProductId
        #
        # 例)
        # Api::V1::Catalog.retrieve("26ed06edf85f6ddc85ccf05a9c633150")
        #
        def self.retrieve(product_id)
          request(:get, "/v1/catalog/product/#{product_id}")
        end
      end
    end
  end
end
