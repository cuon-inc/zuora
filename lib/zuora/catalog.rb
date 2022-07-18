module Zuora
  class Catalog

    # @return [Hash]
    def self.find(id)
      Zuora::Core.find("Catalog", id)
    end

    # @return [Hash]
    def self.find_by(**args)
      Zuora::Core.find_by("Product", **args)
    end

    # @return [Hash]
    def self.last
      records = Zuora::Api::V1::Action.query("select id, sku, name, CreatedDate from Product")["records"]
      id = records.max_by { |h| h["CreatedDate"] }["Id"]
      find(id)
    end
  end
end
