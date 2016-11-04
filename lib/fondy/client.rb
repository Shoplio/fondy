module Fondy
  class Client
    API_HOST = 'https://api.fondy.eu'.freeze

    attr_reader :merchant_id, :password

    def initialize(merchant_id:, password:)
      @merchant_id = merchant_id
      @password = password
    end

    def order_status(order_id)
      params = {
        merchant_id: merchant_id,
        order_id: order_id,
      }
      request(:post, "/api/status/#{order_id}", params)
    end

    private

    def request(method, url, body)
      http_response = http_request(method, url, body)
      Response.new(http_response)
    end

    def http_request(method, url, body)
      connection = Faraday::Connection.new(API_HOST)
      connection.public_send(method) do |request|
        request.url url
        if body
          request.body = { request: body }.to_json
          request.headers['Content-Type'] = 'application/json'
        end
      end
    rescue Faraday::Error => e
      raise Fondy::Error, e.message
    end
  end
end
