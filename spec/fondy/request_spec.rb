require 'spec_helper'

describe Fondy::Request do
  let(:request_headers) do
    {
      'Content-Type' => 'application/json',
    }
  end
  let(:request_body) do
    {
      request: {
        param1: 'value1',
        param2: 'value2',
      },
    }
  end

  def stub_api_request
    stub_request(:post, 'https://api.fondy.eu/api/test')
      .with(
        body: request_body.to_json,
        headers: request_headers,
      )
  end

  def send_request
    described_class.call(:post, '/api/test',
      param1: 'value1',
      param2: 'value2',
    )
  end

  it 'sends request to API' do
    stub = stub_api_request

    send_request

    expect(stub).to have_been_requested
  end

  it 'returns http response' do
    stub_api_request
      .to_return(status: 404, body: 'not found')

    response = send_request

    expect(response.status).to eq(404)
    expect(response.body).to eq('not found')
  end

  it 'raise error if request tumeout' do
    stub_api_request.to_timeout

    expect { send_request }.to raise_error(Fondy::Error, 'execution expired')
  end
end
