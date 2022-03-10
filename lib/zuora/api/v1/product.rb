module Zuora
  module Api
    module V1
      class Product < Base
        #
        # Retrieve Product
        #
        # @param [String] id ProductId
        #
        # 例)
        # Api::V1::Product.retrieve("26ed06edf85f6ddc85ccf05a9c633150")
        #
        def self.retrieve(id)
          request(:get, "/v1/object/product/#{id}")
        end
      end
    end
  end
end
