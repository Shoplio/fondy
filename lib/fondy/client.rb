module Fondy
  class Client
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
      send_request(:post, "/api/status/#{order_id}", params)
    end

    private

    def send_request(*args)
      http_response = Request.call(*args)
      Response.new(http_response)
    end
  end
end
