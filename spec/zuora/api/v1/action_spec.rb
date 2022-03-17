RSpec.describe Zuora::Api::V1::Action do
  include_examples "Zuora::Apiスタブの有効化"
  include_examples "Loggerスタブの有効化"

  describe ".query" do
    subject { described_class.query(query_string) }

    before do
      WebMock.stub_request(:post, "https://rest.apisandbox.zuora.com/v1/action/query")
        .with(
          body: { queryString: query_string },
        )
        .to_return(
          body: response_body,
          status: 200,
        )
    end

    let(:query_string) do
      <<~QUERY
        select AccountId, AccountingCode, AdjustmentDate, AdjustmentNumber,
        Amount, CancelledById, CancelledDate, Comment, CreatedById, CreatedDate,
        InvoiceId, InvoiceItemName, InvoiceNumber, ReferenceId, ServiceEndDate,
        ServiceStartDate, SourceId, SourceType, Status, TransferredToAccounting,
        Type, UpdatedById, UpdatedDate, ReasonCode from InvoiceItemAdjustment
        where Id = '#{key}'
      QUERY
    end

    context "存在するkeyでquery" do
      let(:key) { "2c93808457d787030157e0324aea5158" }
      let(:response_body) { File.read("spec/fixtures/json/zuora_api/response/query_action.json") }

      it "レコードが取得できること" do
        res = subject
        expect(res["done"]).to eq true
        expect(res["size"]).to eq 1
        expect(res["records"][0]["AccountId"]).to eq "2c93808457d787030157e032485b5131"
        expect(res["records"][0]["AccountingCode"]).to eq "Accounts Receivable"
        expect(res["records"][0]["Status"]).to eq "Processed"
      end
    end

    context "存在しないkeyでquery" do
      let(:key) { "hogehoge" }
      let(:response_body) { { "records" => [], "done" => true, "size" => 0 }.to_json }

      it "レコードが取得できないこと" do
        res = subject
        expect(res["done"]).to eq true
        expect(res["size"]).to eq 0
        expect(res["records"]).to eq []
      end
    end
  end
end
