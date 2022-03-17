RSpec.describe Zuora::Api::V1::Base do
  include_examples "Loggerスタブの有効化"

  describe ".oauth_access_token" do
    subject { described_class.oauth_access_token }

    let(:new_oauth_access_token) { instance_double(OAuth2::AccessToken, expired?: false) }

    before do
      described_class.instance_variable_set(:@oauth_access_token, existing_oauth_access_token)
      allow(Zuora::Api::Oauth).to receive(:access_token).and_return(new_oauth_access_token)
    end

    after do
      described_class.instance_variable_set(:@oauth_access_token, nil)
    end

    context "アクセストークン取得済み" do
      let(:existing_oauth_access_token) { instance_double(OAuth2::AccessToken, expired?: expired) }

      context "有効" do
        let(:expired) { false }

        it "アクセストークンを返却する" do
          expect(subject).to eq(existing_oauth_access_token)
          expect(Zuora::Api::Oauth).not_to have_received(:access_token)
        end
      end

      context "無効" do
        let(:expired) { true }

        it "アクセストークンを返却する" do
          expect(subject).to eq(new_oauth_access_token)
          expect(Zuora::Api::Oauth).to have_received(:access_token).once
        end
      end
    end

    context "アクセストークン未取得" do
      let(:existing_oauth_access_token) { nil }

      it "アクセストークンを返却する" do
        expect(subject).to eq(new_oauth_access_token)
        expect(Zuora::Api::Oauth).to have_received(:access_token).once
      end
    end
  end

  describe ".default_headers" do
    subject { described_class.default_headers }

    let(:token) { "token" }

    before do
      allow(described_class).to receive(:oauth_access_token).and_return(instance_double(OAuth2::AccessToken,
                                                                                        token: token))
    end

    it "デフォルトで使用するヘッダの内容を返却する" do
      expect(subject).to eq({ Authorization: "Bearer #{token}", "Content-Type": "application/json" })
    end
  end

  describe ".fail_or_return_response_body" do
    subject { described_class.fail_or_return_response_body(response) }

    let(:response) { instance_double(Faraday::Response, status: 200, body: '{"status": 200}') }

    it "レスポンスの内容をhashとして返却する" do
      expect(subject).to eq({ "status" => 200 })
    end
  end

  describe ".request" do
    subject { described_class.request(method, url, params, headers) }

    let(:url) { "/action" }
    let(:params) { { param: "params value" } }
    let(:headers) { { header: "header value" } }
    let(:default_headers) { { "default-header": "default header value" } }
    let(:response) { '{ "status": 200 }' }
    let(:result) { { "status" => 200 } }

    before do
      allow(described_class).to receive(:default_headers).and_return({ "default-header": "default header value" })
      allow(described_class).to receive(:fail_or_return_response_body).with(response).and_return(result)
      allow(Faraday).to receive(:public_send).with(method,
                                                   "#{config.endpoint}#{url}",
                                                   params,
                                                   headers.merge(default_headers)).and_return(response)
    end

    context "http methodがget" do
      let(:method) { :get }

      it "実行結果を返却する" do
        expect(subject).to eq(result)
      end
    end

    context "http methodがpost" do
      let(:method) { :post }

      it "実行結果を返却する" do
        expect(subject).to eq(result)
      end
    end

    context "http methodがpatch" do
      let(:method) { :patch }

      it "実行結果を返却する" do
        expect(subject).to eq(result)
      end
    end

    context "http methodがput" do
      let(:method) { :put }

      it "実行結果を返却する" do
        expect(subject).to eq(result)
      end
    end

    context "http methodがdelete" do
      let(:method) { :delete }

      it "実行結果を返却する" do
        expect(subject).to eq(result)
      end
    end

    context "http methodが定義外" do
      let(:method) { :option }

      it "エラーが発生する" do
        expect { subject }.to raise_error(ArgumentError, "methodが存在しません")
      end
    end
  end

  describe ".config" do
    subject { described_class.config }

    it "設定情報を返却する" do
      expect(subject.endpoint).to eq(config.endpoint)
      expect(subject.client_id).to eq(config.client_id)
      expect(subject.client_secret).to eq(config.client_secret)
      expect(subject.logger).to eq(logger)
    end
  end
end
