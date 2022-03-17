RSpec.describe Zuora::Api::Oauth do
  describe ".access_token" do
    subject { described_class.access_token }

    let(:config) do
      instance_double(Zuora::Configuration, endpoint: "endpoint", client_id: "client_id",
                                            client_secret: "client_secret")
    end
    let(:client) { instance_double(OAuth2::Client) }
    let(:client_credentials) { instance_double(OAuth2::Strategy::ClientCredentials, get_token: token) }
    let(:token) { instance_double(OAuth2::AccessToken) }

    before do
      allow(Zuora).to receive(:config).and_return(config)
      allow(OAuth2::Client).to receive(:new).with(config.client_id,
                                                  config.client_secret,
                                                  { token_url: "#{config.endpoint}/oauth/token" }).and_return(client)
      allow(client).to receive(:client_credentials).and_return(client_credentials)
    end

    it "アクセス用トークンを返却する" do
      expect(subject).to eq(token)
    end
  end
end
