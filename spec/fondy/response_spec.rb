require 'spec_helper'

describe Fondy::Response do
  before do
    allow(Fondy::Signature).to receive(:build)
      .with(params: hash_including, password: 'pass')
      .and_return('valid_signature')
  end

  let(:http_response) do
    double(
      status: 200,
      body: {
        response: {
          response_status: 'success',
          actual_amount: 100,
          order_status: 'approved',
          signature: 'valid_signature',
        },
      }.to_json,
    )
  end

  let(:response) do
    described_class.new(http_response: http_response, password: 'pass')
  end

  context 'with success response' do
    it '#success? returns true' do
      expect(response.success?).to eq(true)
    end

    it '#error? returns false' do
      expect(response.error?).to eq(false)
    end

    it '#error_code returns nil' do
      expect(response.error_code).to be_nil
    end

    it '#error_message returns nil' do
      expect(response.error_message).to be_nil
    end

    it 'returns response keys data' do
      expect(response.actual_amount).to eq(100)
      expect(response.order_status).to eq('approved')
    end

    it '#respond_to? checks response keys' do
      expect(response.respond_to?(:actual_amount)).to eq(true)
      expect(response.respond_to?(:order_status)).to eq(true)
      expect(response.respond_to?(:other_key)).to eq(false)
    end
  end

  context 'with error response' do
    let(:http_response) do
      double(
        status: 200,
        body: {
          response: {
            response_status: 'failure',
            error_message: 'Order not found',
            error_code: 1018,
          },
        }.to_json,
      )
    end

    it '#success? returns false' do
      expect(response.success?).to eq(false)
    end

    it '#error? returns true' do
      expect(response.error?).to eq(true)
    end

    it '#error_code returns error code' do
      expect(response.error_code).to eq(1018)
    end

    it '#error_message returns error message' do
      expect(response.error_message).to eq('Order not found')
    end
  end

  context 'without signature' do
    let(:http_response) do
      double(
        status: 200,
        body: {
          response: {
            response_status: 'success',
          },
        }.to_json,
      )
    end

    it 'raise error' do
      expect { response }.to raise_error(Fondy::Error, 'Response signature not found')
    end
  end

  context 'with invalid signature' do
    let(:http_response) do
      double(
        status: 200,
        body: {
          response: {
            response_status: 'success',
            signature: 'invalid_signature',
          },
        }.to_json,
      )
    end

    it 'raise error' do
      expect { response }.to raise_error(Fondy::Error, 'Invalid response signature')
    end
  end
end
