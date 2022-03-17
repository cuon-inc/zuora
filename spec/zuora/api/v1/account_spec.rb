RSpec.describe Zuora::Api::V1::Account do
  include_examples "Zuora::Apiスタブの有効化"
  include_examples "Loggerスタブの有効化"

  describe ".create" do
    subject { described_class.create(params) }

    let(:request_params) do
      JSON.parse(File.read("spec/fixtures/json/zuora_api/request/create_account.json"))
    end

    context "アカウント作成成功" do
      before do
        WebMock.stub_request(:post, "https://rest.apisandbox.zuora.com/v1/accounts")
          .with(
            body: params,
          )
          .to_return(
            body: File.read("spec/fixtures/json/zuora_api/response/create_account.json"),
            status: 200,
          )
      end

      let(:params) do
        request_params
      end

      it "作成が成功すること" do
        res = subject
        expect(res["success"]).to eq true
        expect(res["accountId"]).not_to be_nil
        expect(res["accountNumber"]).not_to be_nil
        expect(res["billToContactId"]).not_to be_nil
        expect(res["soldToContactId"]).not_to be_nil
      end
    end

    context "アカウント作成失敗" do
      before do
        WebMock.stub_request(:post, "https://rest.apisandbox.zuora.com/v1/accounts")
          .with(
            body: params,
          )
          .to_return(
            body: File.read("spec/fixtures/json/zuora_api/response/create_account_error.json"),
            status: 200,
          )
      end

      let(:params) do
        request_params.delete("currency")
        request_params
      end

      it "作成が失敗すること" do
        res = subject
        expect(res["success"]).to eq false
        expect(res["processId"]).not_to be_nil
        expect(res["reasons"][0]["code"]).not_to be_nil
        expect(res["reasons"][0]["message"]).to eq "'currency' may not be null"
      end
    end
  end

  describe ".update" do
    subject { described_class.update(account_key, params) }

    let!(:account_key) { "abcd" }

    before do
      WebMock.stub_request(:put, "https://rest.apisandbox.zuora.com/v1/accounts/#{account_key}")
        .with(
          body: params,
        )
        .to_return(
          body: response_body,
          status: 200,
        )
    end

    context "アカウント更新成功" do
      let(:params) { { name: "test" } }
      let(:response_body) { { "success" => true }.to_json }

      it "更新が成功すること" do
        res = subject
        expect(res["success"]).to eq true
      end
    end

    context "アカウント更新失敗" do
      let(:params) { { nam: "test" } }
      let(:response_body) do
        File.read("spec/fixtures/json/zuora_api/response/update_account_error.json")
      end

      it "更新が失敗すること" do
        res = subject
        expect(res["success"]).to eq false
        expect(res["processId"]).not_to be_nil
        expect(res["reasons"][0]["code"]).not_to be_nil
        expect(res["reasons"][0]["message"]).to eq "Invalid parameter(s): 'nam'."
      end
    end
  end

  describe ".retrieve" do
    subject { described_class.retrieve(key) }

    context "存在するkeyのアカウント情報の取得" do
      let(:key) { "402892c74c9193cd014c91d35b0a0132" }

      before do
        WebMock.stub_request(:get, "https://rest.apisandbox.zuora.com/v1/accounts/#{key}")
          .to_return(
            body: File.read("spec/fixtures/json/zuora_api/response/retrieve_account.json"),
            status: 200,
          )
      end

      it "取得できること" do
        res = subject
        expect(res["success"]).to eq true
        expect(res["basicInfo"]["id"]).to eq "402892c74c9193cd014c91d35b0a0132"
        expect(res["basicInfo"]["name"]).to eq "Test"
        expect(res["basicInfo"]["accountNumber"]).to eq "A00000001"
        expect(res["billingAndPayment"]["billCycleDay"]).to eq 1
        expect(res["billingAndPayment"]["currency"]).to eq "USD"
        expect(res["metrics"]["balance"]).to eq 0
        expect(res["billToContact"]["firstName"]).to eq "Test"
        expect(res["billToContact"]["workEmail"]).to eq "contact@example.com"
        expect(res["soldToContact"]["firstName"]).to eq "Test"
        expect(res["soldToContact"]["workEmail"]).to eq "contact@example.com"
      end
    end

    context "存在しないkeyのアカウント情報の取得" do
      let(:key) { "hogehoge" }

      before do
        WebMock.stub_request(:get, "https://rest.apisandbox.zuora.com/v1/accounts/#{key}")
          .to_return(
            body: File.read("spec/fixtures/json/zuora_api/response/retrieve_account_error.json"),
            status: 200,
          )
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
