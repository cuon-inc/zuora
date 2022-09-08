module Zuora
  class Subscription
    # @return [Hash]
    def self.find(id)
      Zuora::Core.find("Subscription", id)
    end

    # @return [Array<Hash>]
    #
    def self.list_by_account_key(account_key)
      res = Zuora::Api::V1::Subscription.list_by_account_key(account_key)
      return [] if res["success"] == false

      res["subscriptions"]
    end
  end
end
