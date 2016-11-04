require 'spec_helper'

describe Fondy::Response do
  let(:http_response) do
    double(
      status: 200,
      body: {
        response: {
          response_status: 'success',
          actual_amount: 100,
          order_status: 'approved',
        }
      }.to_json
    )
  end

  let(:error_http_response) do
    double(
      status: 200,
      body: {
        response: {
          response_status: 'failure',
          error_message: 'Order not found',
          error_code: 1018,
        }
      }.to_json
    )
  end

  let(:response) { described_class.new(http_response) }
  let(:error_response) { described_class.new(error_http_response) }

  it 'returns response keys data' do
    expect(response.actual_amount).to eq(100)
    expect(response.order_status).to eq('approved')
  end

  it '#respond_to? checks response keys' do
    expect(response.respond_to?(:actual_amount)).to eq(true)
    expect(response.respond_to?(:order_status)).to eq(true)
    expect(response.respond_to?(:other_key)).to eq(false)
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
  end

  context 'with error response' do
    it '#success? returns false' do
      expect(error_response.success?).to eq(false)
    end

    it '#error? returns true' do
      expect(error_response.error?).to eq(true)
    end

    it '#error_code returns error code' do
      expect(error_response.error_code).to eq(1018)
    end

    it '#error_message returns error message' do
      expect(error_response.error_message).to eq('Order not found')
    end
  end
end
