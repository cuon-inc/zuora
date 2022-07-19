module Zuora
  class Product
    # @return [Hash]
    def self.find_by(**args)
      Zuora::Core.find_by("Product", **args)
    end
  end
end
