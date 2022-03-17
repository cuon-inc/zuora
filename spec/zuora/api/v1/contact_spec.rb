RSpec.describe Zuora::Api::V1::Contact do
  include_examples "Zuora::Apiスタブの有効化"
  include_examples "Loggerスタブの有効化"

  describe ".create" do
    subject { described_class.create(params) }

    let(:request_params) do
      JSON.parse(File.read("spec/fixtures/json/zuora_api/request/create_contact.json"))
    end

    before do
      WebMock.stub_request(:post, "https://rest.apisandbox.zuora.com/v1/object/contact")
        .with(
          body: params,
        )
        .to_return(
          body: response_body,
          status: status,
        )
    end

    context "作成成功" do
      let(:params) { request_params }
      let(:response_body) { File.read("spec/fixtures/json/zuora_api/response/create_contact.json") }
      let(:status) { 200 }

      it "作成が成功すること" do
        res = subject
        expect(res["Success"]).to eq true
        expect(res["Id"]).not_to be_nil
      end
    end

    context "作成失敗" do
      let(:params) do
        request_params["AccountNumber"] = "123xProxy"
        request_params
      end
      let(:response_body) do
        File.read("spec/fixtures/json/zuora_api/response/create_contact_error.json")
      end
      let(:status) { 400 }

      it "作成が失敗すること" do
        res = subject
        expect(res["Success"]).to eq false
        expect(res["Errors"][0]["Code"]).to eq "INVALID_VALUE"
        expect(res["Errors"][0]["Message"]).to eq "The account number 123xProxy is invalid."
      end
    end
  end

  describe ".update" do
    subject { described_class.update(id, params) }

    before do
      WebMock.stub_request(:put, "https://rest.apisandbox.zuora.com/v1/object/contact/#{id}")
        .to_return(
          body: response_body,
          status: status,
        )
    end

    let(:params) { { FirstName: "hogehoge" } }

    context "更新成功" do
      let(:id) { "8ad084a67dc29b58017dcade54580104" }
      let(:response_body) { File.read("spec/fixtures/json/zuora_api/response/update_contact.json") }
      let(:status) { 200 }

      it "更新が成功すること" do
        res = subject
        expect(res["Success"]).to eq true
        expect(res["Id"]).not_to be_nil
      end
    end

    context "更新失敗" do
      let(:id) { "hogehoge" }
      let(:response_body) do
        File.read("spec/fixtures/json/zuora_api/response/update_contact_error.json")
      end
      let(:status) { 400 }

      it "更新が失敗すること" do
        res = subject
        expect(res["Success"]).to eq false
        expect(res["Errors"][0]["Code"]).to eq "INVALID_ID"
        expect(res["Errors"][0]["Message"]).to eq "invalid id for update"
      end
    end
  end

  describe ".retrieve" do
    subject { described_class.retrieve(key) }

    before do
      WebMock.stub_request(:get, "https://rest.apisandbox.zuora.com/v1/object/contact/#{key}")
        .to_return(
          body: response_body,
          status: status,
        )
    end

    context "存在するkeyの情報の取得" do
      let(:key) { "2c93808457d787030157e02e606e2095" }
      let(:response_body) { File.read("spec/fixtures/json/zuora_api/response/retrieve_contact.json") }
      let(:status) { 200 }

      it "取得できること" do
        res = subject
        expect(res["Id"]).to eq "2c93808457d787030157e02e606e2095"
        expect(res["AccountId"]).to eq "2c93808457d787030157e02e5fde2094"
        expect(res["City"]).to eq "Seattle"
        expect(res["LastName"]).to eq "LN1476934918260"
      end
    end

    context "存在しないkeyの情報の取得" do
      let(:key) { "hogehoge" }
      let(:response_body) do
        File.read("spec/fixtures/json/zuora_api/response/retrieve_contact_error.json")
      end
      let(:status) { 404 }

      it "取得できないこと" do
        res = subject
        expect(res["done"]).to eq true
        expect(res["records"].to_s).to eq "{}"
        expect(res["size"]).to eq 0
      end
    end
  end
end
