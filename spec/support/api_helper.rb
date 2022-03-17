RSpec.shared_context "Zuora::Apiスタブの有効化" do
  before do
    WebMock.enable!
    default_headers = {
      Authorization: "Bearer hogehogetoken",
      "Content-Type": "application/json"
    }
    allow(Zuora::Api::V1::Base).to receive(:default_headers).and_return(default_headers)
  end
end
