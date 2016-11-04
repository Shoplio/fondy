require 'spec_helper'

describe Fondy::Client do
  let(:merchant_id) { 1 }
  let(:password) { 'qwerty' }

  let(:signature) { double }
  let(:http_response) { double }
  let(:response) { double }

  let(:client) { described_class.new(merchant_id: merchant_id, password: password) }

  def stub_signature_with(*args)
    expect(Fondy::Signature).to receive(:build)
      .with(*args)
  end

  def stub_api_request_with(*args)
    expect(Fondy::Request).to receive(:call)
      .with(*args)
  end

  def stub_response_with(*args)
    expect(Fondy::Response).to receive(:new).with(*args)
  end

  describe '#order_status' do
    let(:order_id) { 2 }

    before do
      params = {
        merchant_id: merchant_id,
        order_id: order_id,
      }
      stub_signature_with(params: params, password: password)
        .and_return(signature)
      stub_api_request_with(:post, "/api/status/#{order_id}", params.merge(signature: signature))
        .and_return(http_response)
      stub_response_with(http_response: http_response, password: password)
        .and_return(response)
    end

    it 'sends request to API' do
      client.order_status(order_id)
    end

    it 'returns response' do
      expect(client.order_status(order_id)).to eq(response)
    end
  end
end
