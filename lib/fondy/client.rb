module Fondy
  class Client
    attr_reader :merchant_id, :password

    def initialize(merchant_id:, password:)
      @merchant_id = merchant_id
      @password = password
    end

    def status(order_id:)
      params = {
        merchant_id: merchant_id,
        order_id: order_id,
      }
      send_request(:post, "/api/status/order_id", params)
    end

    def capture(order_id:, amount:, currency:)
      params = {
        merchant_id: merchant_id,
        order_id: order_id,
        amount: amount,
        currency: currency,
      }
      send_request(:post, "/api/capture/order_id", params)
    end

    def reverse(order_id:, amount:, currency:, comment: nil)
      params = {
        merchant_id: merchant_id,
        order_id: order_id,
        amount: amount,
        currency: currency,
      }
      params[:comment] = comment if comment
      send_request(:post, "/api/reverse/order_id", params)
    end

    private

    def send_request(method, url, params)
      params[:signature] = Signature.build(params: params, password: password)
      http_response = Request.call(method, url, params)
      Response.new(http_response: http_response, password: password)
    end
  end
end
