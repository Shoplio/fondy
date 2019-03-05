module Fondy
  class Client
    attr_reader :merchant_id, :password

    def initialize(merchant_id:, password:)
      @merchant_id = merchant_id
      @password = password
    end

    def checkout(order_id:, order_desc:, amount:, currency:, **other_params)
      params = {
        merchant_id: merchant_id,
        order_id: order_id,
        order_desc: order_desc,
        amount: amount,
        currency: currency,
        **other_params,
      }
      send_request(:post, '/api/checkout/url', params, verify_signature: false)
    end

    def status(order_id:)
      params = {
        merchant_id: merchant_id,
        order_id: order_id,
      }
      send_request(:post, '/api/status/order_id', params)
    end

    def capture(order_id:, amount:, currency:)
      params = {
        merchant_id: merchant_id,
        order_id: order_id,
        amount: amount,
        currency: currency,
      }
      send_request(:post, '/api/capture/order_id', params)
    end

    def reverse(order_id:, amount:, currency:, comment: nil)
      params = {
        merchant_id: merchant_id,
        order_id: order_id,
        amount: amount,
        currency: currency,
      }
      params[:comment] = comment if comment
      send_request(:post, '/api/reverse/order_id', params)
    end

    def transaction_list(order_id:)
      params = {
        merchant_id: merchant_id,
        order_id: order_id,
      }
      send_request(:post, '/api/transaction_list', params,
        verify_signature: false,
        response_class: TransactionListResponse,
      )
    end

    private

    def send_request(method, url, params, verify_signature: true, response_class: Response)
      params[:signature] = Signature.build(params: params, password: password)
      http_response = Request.call(method, url, params)
      response = response_class.new(http_response)

      if verify_signature && response.success?
        Signature.verify(params: response.to_h, password: password)
      end

      response
    end
  end
end
