RSpec.describe Zuora do
  it "has a version number" do
    expect(Zuora::VERSION).not_to be nil
  end

  describe ".config" do
    subject { described_class.config }

    context "初期値" do
      it "初期設定されたロガーを返却する" do
        expect(subject.logger).to be_kind_of(Logger)
      end

      it "環境変数に設定されたzuoraのendpointを返却する" do
        expect(subject.endpoint).to eq(ENV["ZUORA_ENDPOINT"])
      end

      it "環境変数に設定されたzuoraのclient_idを返却する" do
        expect(subject.client_id).to eq(ENV["ZUORA_CLIENT_ID"])
      end

      it "環境変数に設定されたzuoraのclient_secretを返却する" do
        expect(subject.client_secret).to eq(ENV["ZUORA_CLIENT_SECRET"])
      end
    end

    context "設定後" do
      let(:any_logger) { instance_double("any logger") }

      before do
        described_class.configure do |config|
          config.endpoint = "any endpoint"
          config.client_id = "any client_id"
          config.client_secret = "any client_secret"
          config.logger = any_logger
        end
      end

      after do
        described_class.configure do |config|
          config.endpoint = ENV["ZUORA_ENDPOINT"]
          config.client_id = ENV["ZUORA_CLIENT_ID"]
          config.client_secret = ENV["ZUORA_CLIENT_SECRET"]
          config.logger = Logger.new($stdout)
        end
      end

      it "設定されたロガーを返却する" do
        expect(subject.logger).to eq(any_logger)
      end

      it "設定されたzuoraのendpointを返却する" do
        expect(subject.endpoint).to eq("any endpoint")
      end

      it "設定されたzuoraのclient_idを返却する" do
        expect(subject.client_id).to eq("any client_id")
      end

      it "設定されたzuoraのclient_secretを返却する" do
        expect(subject.client_secret).to eq("any client_secret")
      end
    end
  end
end
