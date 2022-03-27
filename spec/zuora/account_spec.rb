RSpec.describe Zuora::Account do
  describe ".carete!" do
    subject { described_class.create!(params) }

    let(:request_params) do
      JSON.parse(File.read("spec/fixtures/json/zuora_api/request/create_account.json"))
    end

    context "正常なparams" do
      let(:params) do
        request_params
      end

      before do
        response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/create_account.json"),
        )
        allow(Zuora::Api::V1::Account).to receive(:create).and_return(response)
        find_response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/retrieve_account.json"),
        )
        allow(Zuora::Core).to receive(:find).and_return(find_response)
      end

      it "レコードが取得できること" do
        res = subject
        expect(res["success"]).to be true
        expect(res["basicInfo"]["id"]).to eq "402892c74c9193cd014c91d35b0a0132"
        expect(res["basicInfo"]["name"]).to eq "Test"
      end
    end

    context "不正なparams" do
      let(:params) do
        request_params.delete("currency")
        request_params
      end

      before do
        response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/create_account_error.json"),
        )
        allow(Zuora::Api::V1::Account).to receive(:create).and_return(response)
      end

      it "例外が起きること" do
        expect { subject }.to raise_error(Zuora::Core::RecordInvalid, "[\"'currency' may not be null\"]")
      end
    end
  end

  describe ".update!" do
    subject { described_class.update!("2c93808457d787030157e0324aea5158", params) }

    context "正常なparams" do
      let(:params) { { name: "test" } }

      before do
        allow(Zuora::Api::V1::Account).to receive(:update).and_return({ "success" => true })
        find_response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/retrieve_account.json"),
        )
        allow(Zuora::Core).to receive(:find).and_return(find_response)
      end

      it "レコードが取得できること" do
        res = subject
        expect(res["success"]).to be true
        expect(res["basicInfo"]["id"]).to eq "402892c74c9193cd014c91d35b0a0132"
        expect(res["basicInfo"]["name"]).to eq "Test"
      end
    end

    context "不正なparams" do
      let(:params) { { nam: "test" } }

      before do
        response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/update_account_error.json"),
        )
        allow(Zuora::Api::V1::Account).to receive(:update).and_return(response)
      end

      it "例外が起きること" do
        expect do
          subject
        end.to raise_error(Zuora::Core::RecordInvalid, "[\"Invalid parameter(s): 'nam'.\"]")
      end
    end
  end

  describe ".find_by" do
    subject { described_class.find_by(crmId: crm_id) }

    context "存在するデータのparams" do
      let(:crm_id) { "001E0000016PJT7IAO" }

      before do
        response = { "records" => [{ "Id" => "402892c74c9193cd014c91d35b0a0132" }], "done" => true, "size" => 1 }
        allow(Zuora::Api::V1::Action).to receive(:query).and_return(response)
        find_response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/retrieve_account.json"),
        )
        allow(Zuora::Core).to receive(:find).and_return(find_response)
      end

      it "レコードが取得できること" do
        res = subject
        expect(res["success"]).to be true
        expect(res["basicInfo"]["id"]).to eq "402892c74c9193cd014c91d35b0a0132"
        expect(res["basicInfo"]["name"]).to eq "Test"
      end
    end

    context "存在しないデータのparams" do
      let(:crm_id) { "HOGEHOGE" }

      before do
        response = { "records" => [], "done" => true, "size" => 0 }
        allow(Zuora::Api::V1::Action).to receive(:query).and_return(response)
      end

      it "niが返ること" do
        res = subject
        expect(res).to be_nil
      end
    end
  end
end
