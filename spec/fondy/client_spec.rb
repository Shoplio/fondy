require 'spec_helper'

describe Fondy::Client do
  let(:merchant_id) { 1 }
  let(:password) { 'qwerty' }

  let(:client) { described_class.new(merchant_id: merchant_id, password: password) }

  describe '#order_status' do
    let(:order_id) { 2 }

    let(:request_headers) do
      {
        'Content-Type' => 'application/json',
      }
    end
    let(:request_body) do
      {
        request: {
          merchant_id: merchant_id,
          order_id: order_id,
        },
      }
    end

    let(:response_body) do
      {
        response: {
          actual_amount: 1000,
          order_status: 'approved',
        },
      }
    end

    let!(:stub_api) do
      stub_request(:post, "https://api.fondy.eu/api/status/#{order_id}")
        .with(body: request_body.to_json, headers: request_headers)
        .to_return(body: response_body.to_json)
    end

    it 'sends request to API' do
      client.order_status(order_id)

      expect(stub_api).to have_been_requested
    end

    it 'returns value object' do
      response = client.order_status(order_id)

      expect(response.respond_to?(:actual_amount)).to eq(true)
      expect(response.respond_to?(:order_status)).to eq(true)

      expect(response.actual_amount).to eq(1000)
      expect(response.order_status).to eq('approved')
    end
  end
end
