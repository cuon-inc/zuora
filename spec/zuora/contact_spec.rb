RSpec.describe Zuora::Contact do
  describe ".carete!" do
    subject { described_class.create!(params) }

    let(:request_params) do
      JSON.parse(File.read("spec/fixtures/json/zuora_api/request/create_contact.json"))
    end

    context "正常なparams" do
      let(:params) do
        request_params
      end

      before do
        response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/create_contact.json"),
        )
        allow(Zuora::Api::V1::Contact).to receive(:create).and_return(response)
        find_response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/retrieve_contact.json"),
        )
        allow(Zuora::Core).to receive(:find).and_return(find_response)
      end

      it "レコードが取得できること" do
        res = subject
        expect(res["Id"]).not_to be_nil
        expect(res["FirstName"]).to eq "FN1476934918260_new"
        expect(res["WorkEmail"]).to eq "work@example.com"
      end
    end

    context "不正なparams" do
      let(:params) do
        request_params["AccountId"] = "123xProxy"
        request_params
      end

      before do
        response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/create_contact_error.json"),
        )
        allow(Zuora::Api::V1::Contact).to receive(:create).and_return(response)
      end

      it "例外が起きること" do
        expect do
          subject
        end.to raise_error(Zuora::Core::RecordInvalid, "[\"The account number 123xProxy is invalid.\"]")
      end
    end
  end

  describe ".update!" do
    subject { described_class.update!(id, params) }

    let(:params) { { FirstName: "hogehoge" } }

    context "存在するid" do
      let(:id) { "8ad084a67dc29b58017dcade54580104" }

      before do
        response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/update_contact.json"),
        )
        allow(Zuora::Api::V1::Contact).to receive(:update).and_return(response)
        find_response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/retrieve_contact.json"),
        )
        allow(Zuora::Core).to receive(:find).and_return(find_response)
      end

      it "レコードが取得できること" do
        res = subject
        expect(res["Id"]).not_to be_nil
        expect(res["FirstName"]).to eq "FN1476934918260_new"
        expect(res["WorkEmail"]).to eq "work@example.com"
      end
    end

    context "存在しないid" do
      let(:id) { "hogehoge" }

      before do
        response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/update_contact_error.json"),
        )
        allow(Zuora::Api::V1::Contact).to receive(:update).and_return(response)
      end

      it "例外が起きること" do
        expect do
          subject
        end.to raise_error(Zuora::Core::RecordInvalid, "[\"invalid id for update\"]")
      end
    end
  end

  describe ".find_by" do
    context "存在するデータのparams" do
      let(:execute) do
        described_class.find_by(AccountId: "a5deb3e3a10def5ec4d884b3f52c2e72", LastName: "Jones",
                                FirstName: "FN1476934918260_new",
                                WorkEmail: 'work@example.com"')
      end

      before do
        response = { "records" => [{ "Id" => "a5deb3e3e03b0ec0e27ee5c0b19d0ad0" }], "done" => true, "size" => 1 }
        allow(Zuora::Api::V1::Action).to receive(:query).and_return(response)
        find_response = JSON.parse(
          File.read("spec/fixtures/json/zuora_api/response/retrieve_contact.json"),
        )
        allow(Zuora::Core).to receive(:find).and_return(find_response)
      end

      it "レコードが取得できること" do
        res = execute
        expect(res["Id"]).not_to be_nil
        expect(res["FirstName"]).to eq "FN1476934918260_new"
        expect(res["WorkEmail"]).to eq "work@example.com"
      end
    end

    context "存在しないデータのparams" do
      let(:execute) do
        described_class.find_by(AccountId: "hogehoge", LastName: "Jones", FirstName: "FN1476934918260_new",
                                WorkEmail: 'work@example.com"')
      end

      before do
        response = { "records" => [], "done" => true, "size" => 0 }
        allow(Zuora::Api::V1::Action).to receive(:query).and_return(response)
      end

      it "niが返ること" do
        res = execute
        expect(res).to be_nil
      end
    end
  end
end
