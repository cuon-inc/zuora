RSpec.shared_context "Loggerスタブの有効化" do
  let(:config) { Zuora.config }
  let(:logger) { instance_spy(Logger) }

  before do
    allow(Zuora).to receive(:config).and_return(config)
    allow(config).to receive(:endpoint).and_call_original
    allow(config).to receive(:client_id).and_call_original
    allow(config).to receive(:client_secret).and_call_original
    allow(config).to receive(:logger).and_return(logger)
  end
end
