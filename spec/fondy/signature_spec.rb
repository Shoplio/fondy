require 'spec_helper'

describe Fondy::Signature do
  let(:params) do
    {
      order_id: 'test123456',
      order_desc: 'test order',
      currency: 'USD',
      amount: '125',
      signature: 'f0ee6288b9295d3b808bcd8d720211c7201245e1',
      merchant_id: '1396424',
    }
  end

  it 'build sinature from params and password' do
    signature = Fondy::Signature.build(params: params, password: 'test')
    expected_signature = Digest::SHA1.hexdigest('test|125|USD|1396424|test order|test123456')

    expect(signature).to eq(expected_signature)
  end
end
