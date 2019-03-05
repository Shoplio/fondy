require 'spec_helper'

describe Fondy::Client do
  let(:merchant_id) { 1 }
  let(:password) { 'qwerty' }

  let(:order_id) { 2 }
  let(:order_desc) { 'Test order' }
  let(:amount) { 100 }
  let(:currency) { 'USD' }

  let(:signature) { double }
  let(:http_response) { double }
  let(:response) { double(success?: true, to_h: {}) }
  let(:response_class) { Fondy::Response }

  let(:client) { described_class.new(merchant_id: merchant_id, password: password) }

  shared_examples 'api method' do
    def stub_signature_with(*args)
      expect(Fondy::Signature).to receive(:build)
        .with(*args)
    end

    def stub_api_request_with(*args)
      expect(Fondy::Request).to receive(:call)
        .with(*args)
    end

    def stub_response_with(response_class, *args)
      expect(response_class).to receive(:new).with(*args)
    end

    def stub_verify_signature_with(*args)
      expect(Fondy::Signature).to receive(:verify)
        .with(*args)
    end

    before do
      stub_signature_with(params: post_params, password: password)
        .and_return(signature)
      stub_api_request_with(:post, post_url, post_params.merge(signature: signature))
        .and_return(http_response)
      stub_response_with(response_class, http_response)
        .and_return(response)

      if verify_signature
        stub_verify_signature_with(params: response.to_h, password: password)
          .and_return(true)
      end
    end

    it 'sends request to API' do
      subject
    end

    it 'returns response' do
      expect(subject).to eq(response)
    end
  end


  describe '#checkout' do
    subject do
      client.checkout(
        order_id: order_id,
        order_desc: order_desc,
        amount: amount,
        currency: currency,
        preauth: 'Y',
      )
    end

    let(:post_url) { '/api/checkout/url' }
    let(:post_params) do
      {
        merchant_id: merchant_id,
        order_id: order_id,
        order_desc: order_desc,
        amount: amount,
        currency: currency,
        preauth: 'Y',
      }
    end

    let(:verify_signature) { false }

    it_behaves_like 'api method'
  end

  describe '#status' do
    subject do
      client.status(order_id: order_id)
    end

    let(:post_url) { '/api/status/order_id' }
    let(:post_params) do
      {
        merchant_id: merchant_id,
        order_id: order_id,
      }
    end

    let(:verify_signature) { true }

    it_behaves_like 'api method'
  end

  describe '#capture' do
    subject do
      client.capture(order_id: order_id, amount: amount, currency: currency)
    end

    let(:post_url) { '/api/capture/order_id' }
    let(:post_params) do
      {
        merchant_id: merchant_id,
        order_id: order_id,
        amount: amount,
        currency: currency,
      }
    end

    let(:verify_signature) { true }

    it_behaves_like 'api method'
  end

  describe '#reverse' do
    subject do
      client.reverse(order_id: order_id, amount: amount, currency: currency)
    end

    let(:post_url) { '/api/reverse/order_id' }
    let(:post_params) do
      {
        merchant_id: merchant_id,
        order_id: order_id,
        amount: amount,
        currency: currency,
      }
    end

    let(:verify_signature) { true }

    it_behaves_like 'api method'
  end

  describe '#transaction_list' do
    subject do
      client.transaction_list(order_id: order_id)
    end

    let(:post_url) { '/api/transaction_list' }
    let(:post_params) do
      {
        merchant_id: merchant_id,
        order_id: order_id,
      }
    end

    let(:verify_signature) { false }

    let(:response_class) { Fondy::TransactionListResponse }

    it_behaves_like 'api method'
  end
end
