# frozen_string_literal: true
require 'spec_helper'

describe Fondy::Signature do
  let(:password) { 'test' }
  let(:params) do
    {
      order_id: 'test123456',
      order_desc: 'test order',
      currency: 'USD',
      amount: '125',
      signature: 'f0ee6288b9295d3b808bcd8d720211c7201245e1',
      merchant_id: '1396424',
      response_signature_string: '****|125|USD|1396424|test order|test123456',
      blank_param: '',
    }
  end

  let(:expected_signature) do
    Digest::SHA1.hexdigest("#{password}|125|USD|1396424|test order|test123456")
  end

  describe '#build' do
    it 'build sinature from params and password' do
      signature = Fondy::Signature.build(params: params, password: password)
      expect(signature).to eq(expected_signature)
    end
  end

  describe '#verify' do
    subject do
      Fondy::Signature.verify(params: params, password: password)
    end

    context 'without signature' do
      before do
        params.delete(:signature)
      end

      it 'raise error' do
        expect { subject }.to raise_error(Fondy::Error, 'Response signature not found')
      end
    end

    context 'with invalid signature' do
      it 'raise error' do
        expect { subject }.to raise_error(Fondy::Error, 'Invalid response signature')
      end
    end

    context 'with valid signature' do
      before do
        params[:signature] = expected_signature
      end

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end
  end
end
