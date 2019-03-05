require 'spec_helper'

describe Fondy::TransactionListResponse do
  let(:http_response) do
    double(
      status: 200,
      body: {
        response: [
          {
            id: 1,
            transaction_status: 'approved',
          },
          {
            id: 2,
            transaction_status: 'declined',
          },
        ],
      }.to_json,
    )
  end

  let(:response) do
    described_class.new(http_response)
  end

  context 'with success response' do
    it '#transactions returns array' do
      transactions = [
        {
          id: 1,
          transaction_status: 'approved',
        },
        {
          id: 2,
          transaction_status: 'declined',
        },
      ]
      expect(response.transactions).to eq(transactions)
    end

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

    it '#transactions returns empty array' do
      expect(response.transactions).to eq([])
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
end
