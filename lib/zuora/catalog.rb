module Zuora
  class Catalog

    # @return [Hash]
    def self.find(id)
      Zuora::Core.find("Catalog", id)
    end

    # @return [Hash]
    def self.find_by(**args)
      product = Zuora::Product.find_by(**args)
      return if product.nil?
      find(product['Id'])
    end

    # @return [Hash]
    def self.last
      records = Zuora::Api::V1::Action.query("select id, sku, name, CreatedDate from Product")["records"]
      id = records.max_by { |h| h["CreatedDate"] }["Id"]
      find(id)
    end
  end
end
