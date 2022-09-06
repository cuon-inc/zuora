RSpec.describe Zuora::Core do
  let(:object_name) { "ObjectName" }

  before do
    stub_const("Zuora::Api::V1::ObjectName", instance_double("ObjectName"))
  end

  include_examples "Loggerスタブの有効化"

  describe ".find" do
    subject { described_class.find(object_name, id) }

    let(:result) { { "success" => true } }
    let(:id) { "id" }

    before do
      allow(Zuora::Api::V1::ObjectName).to receive(:retrieve).with(id).and_return(result)
    end

    context "ID未指定" do
      let(:id) { nil }

      it "エラーが発生する" do
        expect { subject }.to raise_error(Zuora::Core::RecordNotFound, "Couldn't find ")
      end
    end

    context "レスポンスのsuccessがfalse値" do
      let(:result) { { "success" => false } }

      it "エラーが発生する" do
        expect { subject }.to raise_error(Zuora::Core::RecordNotFound, "Couldn't find #{id}")
      end
    end

    context "レスポンスのIdが存在しない" do
      let(:result) { {} }

      it "エラーが発生する" do
        expect { subject }.to raise_error(Zuora::Core::RecordNotFound, "Couldn't find #{id}")
      end
    end

    context "正常なレスポンス" do
      it "値が取得できる" do
        expect(subject).to eq(result)
      end
    end
  end

  describe ".find_by" do
    subject { described_class.find_by(object_name, args) }

    let(:args) { { key1: "key1", key2: nil, key3: :key3 } }
    let(:record) { instance_double("result") }
    let(:data) { { "records" => [record, instance_double("result", Id: "id2")] } }
    let(:attrs) { { Id: "id1" } }

    before do
      allow(Zuora::Api::V1::Action).to receive(:query)
        .with("select Id from #{object_name} where key1 = 'key1' AND key2 = null AND key3 = key3").and_return(data)
      allow(record).to receive(:[]).with("Id").and_return(attrs["Id"])
    end

    context "存在するID" do
      before do
        allow(described_class).to receive(:find).with(object_name, record["Id"]).and_return(attrs)
      end

      it "値が取得できる" do
        expect(subject).to eq(attrs)
      end
    end

    context "存在しないID" do
      before do
        allow(described_class).to receive(:find).with(object_name, record["Id"]).and_raise(Zuora::Core::RecordNotFound)
      end

      it "値が取得できない" do
        expect(subject).to be_nil
      end
    end
  end

  describe ".create!" do
    subject { described_class.create!(object_name, params, id_key_name) }

    let(:params) { { Attribute__c: "test" } }
    let(:id_key_name) { "id_key_name" }
    let(:attrs) { { Id: "id1" } }

    before do
      allow(Zuora::Api::V1::ObjectName).to receive(:create).with(params).and_return(create_result)
    end

    context "作成成功" do
      let(:create_result) { { "success" => true, id_key_name => "id1" } }

      before do
        allow(described_class).to receive(:find).with(object_name, "id1").and_return(attrs)
      end

      it "作成したオブジェクトを返却する" do
        expect(subject).to eq(attrs)
      end
    end

    context "作成失敗" do
      let(:create_result) do
        { "success" => false, "reasons" => [{ "message" => "ERROR1" }, { "message" => "ERROR2" }] }
      end

      it "エラーが発生する" do
        expect { subject }.to raise_error(Zuora::Core::RecordInvalid, '["ERROR1", "ERROR2"]')
        expect(logger).to have_received(:error).with("[Zuora][#{object_name}] Cound't create")
      end
    end
  end

  describe ".update!" do
    subject { described_class.update!(object_name, id, params) }

    let(:params) { { Attribute__c: "test" } }
    let(:id) { "id1" }
    let(:attrs) { { Id: "id1" } }

    before do
      allow(Zuora::Api::V1::ObjectName).to receive(:update).with(id, params).and_return(update_result)
    end

    context "更新成功" do
      let(:update_result) { { "Success" => true } }

      before do
        allow(described_class).to receive(:find).with(object_name, id).and_return(attrs)
      end

      it "更新したオブジェクトを返却する" do
        expect(subject).to eq(attrs)
      end
    end

    context "更新失敗" do
      let(:update_result) { { "Success" => false, "Errors" => [{ "Message" => "ERROR1" }, { "Message" => "ERROR2" }] } }

      it "エラーが発生する" do
        expect { subject }.to raise_error(Zuora::Core::RecordInvalid, '["ERROR1", "ERROR2"]')
        expect(logger).to have_received(:error).with("[Zuora][#{object_name}] Cound't update")
      end
    end
  end

  describe "._first" do
    subject { described_class._first(object_name) }

    let(:result) do
      { "records" => [{ "Id" => "hoge1", "CreatedDate" => "2022-07-05T14:01:58.000+09:00" },
                      { "Id" => "hoge2", "CreatedDate" => "2022-07-05T14:30:58.000+09:00" },
                      { "Id" => "hoge3", "CreatedDate" => "2022-07-06T14:30:58.000+09:00" }] }
    end

    before do
      allow(Zuora::Api::V1::Action).to receive(:query).and_return(result)
      allow(described_class).to receive(:find).with("hoge1")
        .and_return({ Id: "hoge1" })
    end

    it "作成時間が最小のレコードidが取得できること" do
      expect(subject).to eq({ Id: "hoge1" })
    end
  end

  describe "._last" do
    subject { described_class._last(object_name) }

    let(:result) do
      { "records" => [{ "Id" => "hoge1", "CreatedDate" => "2022-07-05T14:01:58.000+09:00" },
                      { "Id" => "hoge2", "CreatedDate" => "2022-07-05T14:30:58.000+09:00" },
                      { "Id" => "hoge3", "CreatedDate" => "2022-07-06T14:30:58.000+09:00" }] }
    end

    before do
      allow(Zuora::Api::V1::Action).to receive(:query).and_return(result)
      allow(described_class).to receive(:find).with("hoge3")
        .and_return({ Id: "hoge3" })
    end

    it "作成時間が最大のレコードidが取得できること" do
      expect(subject).to eq({ Id: "hoge3" })
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
