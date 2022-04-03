module Zuora
  class Subscription
    # @return [Array<Hash>]
    #
    def self.list_by_account_key(account_key)
      res = Zuora::Api::V1::Subscription.list_by_account_key(account_key)
      return [] if res["success"] == false

      res["subscriptions"]
    end
  end
end
