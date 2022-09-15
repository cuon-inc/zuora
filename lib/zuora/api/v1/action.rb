module Zuora
  module Api
    module V1
      class Action < Base
        #
        # @params [String] query_sring ZOQL文字列(https://knowledgecenter.zuora.com/Central_Platform/Query/ZOQL)
        #
        # 例)
        # Api::V1::Action.query("select id, sku, name from Product")
        # Api::V1::Action.query("select id, name from Account")
        # Api::V1::Action.query("select id, name from Subscription", { "X-Zuora-WSDL-Version": "124" })
        #
        # TODO: クラスをリソース単位としたI/F実装。統一検討。
        def self.query(query_string, headers = {})
          request(:post, "/v1/action/query", { queryString: query_string }.to_json, headers)
        end
      end
    end
  end
end
