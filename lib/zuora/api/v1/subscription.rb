module Zuora
  module Api
    module V1
      class Subscription < Base
        #
        # List subscriptions by account key
        #
        # @param [String] account_key アカウント番号
        # @param [Integer] page ページ番号
        # @param [Integer] page_size ページサイズ
        #
        # 例)
        # Api::V1::Subscription.list_by_account_key("26ed06ed007a4807f5bae9e0cf616948")
        #
        def self.list_by_account_key(account_key, page: 1, page_size: 20)
          request(:get, "/v1/subscriptions/accounts/#{account_key}", { page: page, pageSize: page_size })
        end
      end
    end
  end
end
