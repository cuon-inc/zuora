module Zuora
  class Order
    # @return [Array<Hash>] Zuora::Order
    def self.all
      # TODO: ページネーション検討
      Zuora::Api::V1::Order.list
    end

    # @params [String] id OrderNumber
    # @return [Hash] Zuora::Order
    def self.find(id)
      res = Zuora::Core.find("Order", id)
      res["order"]
    end

    #  params = {
    #    description: "This is a description for the Order.",
    #    existingAccountNumber: "A00000515",
    #    orderDate: "2017-01-01",
    #    subscriptions: [
    #      {
    #        orderActions: [
    #          createSubscription: {
    #            subscriptionOwnerAccountNumber: "A00000511",
    #            subscribeToRatePlans: [
    #              productRatePlanId: "26ed06ed86febf5993090dc3a58ce4e4",
    #            ],
    #            terms: {
    #              initialTerm: {
    #                termType: "EVERGREEN"
    #              }
    #            }
    #          },
    #          type: "CreateSubscription",
    #        ]
    #      },
    #    ]
    #  }
    #  o = Zuora::Order.create!(params)
    # @params [Hash] params
    def self.create!(params)
      Zuora::Core.create!("Order", params, "orderNumber")
    end

    def self.destroy!(order_number)
      # TODO: coreを使う
      Zuora::Api::V1::Order.delete(order_number)
    end
  end
end
