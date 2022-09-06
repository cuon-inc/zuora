RSpec.describe Zuora::Api::V1::Subscription do
  include_examples "Zuora::Apiスタブの有効化"
  include_examples "Loggerスタブの有効化"

  describe ".retrieve" do
    subject { described_class.retrieve(key) }

    before do
      WebMock.stub_request(:get, "https://rest.apisandbox.zuora.com/v1/subscriptions/#{key}")
        .to_return(
          body: response_body,
          status: 200,
        )
    end

    context "存在するkeyの情報取得" do
      let(:key) { "A-S00023298" }
      let(:response_body) { File.read("spec/fixtures/json/zuora_api/response/retrieve_subscription.json") }

      it "取得できること" do
        res = subject
        expect(res["success"]).to eq true
        expect(res["subscriptionNumber"]).to eq "A-S00023298"
        expect(res["id"]).to eq "8ad09b7d830721b501830b0d04fb30c6"
        expect(res["initialTermPeriodType"]).to eq "Month"
      end
    end

    context "存在しないkeyの情報取得" do
      let(:key) { "hogehoge" }
      let(:response_body) do
        File.read("spec/fixtures/json/zuora_api/response/retrieve_subscription_error.json")
      end

      it "取得できないこと" do
        res = subject
        expect(res["success"]).to eq false
        expect(res["processId"]).not_to be_nil
        expect(res["reasons"][0]["code"]).to eq 50_000_040
        expect(res["reasons"][0]["message"]).to eq "Cannot find entity by key: 'hogehoge'."
      end
    end
  end
end
