require "zuora/version"
require "zuora/core"
require "zuora/config"
require "zuora/api/oauth"

require "active_support/all"
require "faraday"
require "oauth2"

module Zuora
  autoload :Account, "zuora/account"
  autoload :Contact, "zuora/contact"
  autoload :Order, "zuora/order"
  autoload :Subscription, "zuora/subscription"
  autoload :Catalog, "zuora/catalog"
  autoload :Product, "zuora/product"
  module Api
    module V1
      autoload :Account, "zuora/api/v1/account"
      autoload :Action, "zuora/api/v1/action"
      autoload :Base, "zuora/api/v1/base"
      autoload :Catalog, "zuora/api/v1/catalog"
      autoload :Contact, "zuora/api/v1/contact"
      autoload :Order, "zuora/api/v1/order"
      autoload :Product, "zuora/api/v1/product"
      autoload :ProductRatePlan, "zuora/api/v1/product_rate_plan"
      autoload :ProductRatePlanCharge, "zuora/api/v1/product_rate_plan_charge"
      autoload :Subscription, "zuora/api/v1/subscription"
    end
  end
end
