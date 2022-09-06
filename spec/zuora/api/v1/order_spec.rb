RSpec.describe Zuora::Api::V1::Order do
  include_examples "Zuora::Apiスタブの有効化"
  include_examples "Loggerスタブの有効化"

  describe ".create" do
    subject { described_class.create(params) }

    let(:request_params) do
      JSON.parse(File.read("spec/fixtures/json/zuora_api/request/create_order.json"))
    end

    before do
      WebMock.stub_request(:post, "https://rest.apisandbox.zuora.com/v1/orders")
        .with(
          body: params,
        )
        .to_return(
          body: response_body,
          status: 200,
        )
    end

    context "作成成功" do
      let(:params) { request_params }
      let(:response_body) { File.read("spec/fixtures/json/zuora_api/response/create_order.json") }

      it "作成が成功すること" do
        res = subject
        expect(res["success"]).to eq true
        expect(res["orderNumber"]).to eq "OM-00002"
        expect(res["accountNumber"]).to eq "A00000001"
        expect(res["status"]).to eq "Pending"
        expect(res["subscriptions"]).not_to be_nil
        expect(res["invoiceNumbers"][0]).to eq "INV00000001"
        expect(res["paidAmount"]).to eq 300
      end
    end

    context "作成失敗" do
      let(:params) do
        request_params["existingAccountNumber"] = "hogehoge"
        request_params
      end
      let(:response_body) do
        File.read("spec/fixtures/json/zuora_api/response/create_order_error.json")
      end

      it "作成が失敗すること" do
        res = subject
        expect(res["success"]).to eq false
        expect(res["processId"]).not_to be_nil
        expect(res["reasons"][0]["code"]).to eq 58_560_040
        expect(res["reasons"][0]["message"]).to eq "Cannot find entity by key: 'hogehoge'."
      end
    end
  end

  describe ".retrieve" do
    subject { described_class.retrieve(key) }

    before do
      WebMock.stub_request(:get, "https://rest.apisandbox.zuora.com/v1/orders/#{key}")
        .to_return(
          body: response_body,
          status: 200,
        )
    end

    context "存在するkeyの情報取得" do
      let(:key) { "O-00000282" }
      let(:response_body) { File.read("spec/fixtures/json/zuora_api/response/retrieve_order.json") }

      it "取得できること" do
        res = subject
        expect(res["success"]).to eq true
        expect(res["order"]["orderNumber"]).to eq "O-00000282"
        expect(res["order"]["orderDate"]).to eq "2018-10-01"
      end
    end

    context "存在しないkeyの情報取得" do
      let(:key) { "hogehoge" }
      let(:response_body) do
        File.read("spec/fixtures/json/zuora_api/response/retrieve_order_error.json")
      end

      it "取得できないこと" do
        res = subject
        expect(res["success"]).to eq false
        expect(res["processId"]).not_to be_nil
        expect(res["reasons"][0]["code"]).to eq 50_000_020
        expect(res["reasons"][0]["message"]).to eq "Invalid orderNumber: hogehoge"
      end
    end
  end

  describe ".list" do
    subject { described_class.list(page: 1, page_size: 2) }

    before do
      WebMock.stub_request(:get, "https://rest.apisandbox.zuora.com/v1/orders?page=1&pageSize=2")
        .to_return(
          body: File.read("spec/fixtures/json/zuora_api/response/list_order.json"),
          status: 200,
        )
    end

    it "指定件数分取得できること" do
      res = subject
      expect(res["orders"][1]["success"]).to eq true
      expect(res["orders"].size).to eq 2
      expect(res["orders"][0]["orderNumber"]).to eq "O-00000002"
      expect(res["orders"][1]["orderNumber"]).to eq "O-00000001"
    end
  end

  describe ".list_by_account_number" do
    subject { described_class.list_by_account_number(account_number, page: 1, page_size: 2) }

    before do
      WebMock.stub_request(:get, "https://rest.apisandbox.zuora.com/v1/orders/invoiceOwner/#{account_number}?page=1&pageSize=2")
        .to_return(
          body: File.read("spec/fixtures/json/zuora_api/response/list_by_account_number_order.json"),
          status: 200,
        )
    end

    context "指定件数分取得" do
      let(:account_number) { "A00001886" }

      it "指定件数分取得できること" do
        res = subject
        expect(res["success"]).to eq true
        expect(res["orders"].size).to eq 2
        expect(res["orders"][0]["orderNumber"]).to eq "O-00060210"
        expect(res["orders"][1]["orderNumber"]).to eq "O-00060209"
      end
    end
  end

  describe ".delete" do
    subject { described_class.delete(key) }

    before do
      WebMock.stub_request(:delete, "https://rest.apisandbox.zuora.com/v1/orders/#{key}")
        .to_return(
          body: response_body,
          status: 200,
        )
    end

    context "存在するkeyの削除" do
      let(:key) { "O-00000282" }
      let(:response_body) { { success: true }.to_json }

      it "削除できること" do
        res = subject
        expect(res["success"]).to eq true
      end
    end

    context "存在しないkeyの削除" do
      let(:key) { "hogehoge" }
      let(:response_body) do
        File.read("spec/fixtures/json/zuora_api/response/delete_order_error.json")
      end

      it "削除できないこと" do
        res = subject
        expect(res["success"]).to eq false
        expect(res["processId"]).not_to be_nil
        expect(res["reasons"][0]["code"]).to eq 50_000_040
        expect(res["reasons"][0]["message"]).to eq "Invalid orderNumber: hogehoge"
      end
    end
  end
end
