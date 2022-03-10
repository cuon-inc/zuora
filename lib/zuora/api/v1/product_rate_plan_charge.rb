module Zuora
  module Api
    module V1
      class ProductRatePlanCharge < Base
        #
        # Retrieve ProductRatePlanCharge
        #
        # @param [String] id ProductRatePlanChargeId
        #
        # 例)
        # Api::V1::ProductRatePlanCharge.retrieve("26ed06ed941dffadb9baac409dd0b2df")
        #
        def self.retrieve(id)
          request(:get, "/v1/object/product-rate-plan-charge/#{id}")
        end
      end
    end
  end
end
