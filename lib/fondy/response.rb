module Fondy
  class Response
    def initialize(http_response:, password:)
      @http_response = http_response
      check_signature(password) if success?
    end

    def success?
      response['response_status'] == 'success'
    end

    def error?
      !success?
    end

    def error_code
      response['error_code']
    end

    def error_message
      response['error_message']
    end

    def method_missing(method, *_args)
      response[method.to_s] || super
    end

    def respond_to_missing?(method, *_args)
      response.key?(method.to_s)
    end

    private

    # rubocop:disable Style/GuardClause
    def check_signature(password)
      signature = response['signature']
      unless signature
        raise Fondy::InvalidSignatureError, 'Response signature not found'
      end

      expected_signature = Signature.build(params: response, password: password)
      unless signature == expected_signature
        raise Fondy::InvalidSignatureError, 'Invalid response signature'
      end
    end

    def response
      @response ||= json_body['response'] || raise(Fondy::Error, 'Invalid response')
    end

    def json_body
      @json_body ||=
        begin
          JSON.parse(@http_response.body)
        rescue
          raise Fondy::InvalidResponseError, 'Invalid response'
        end
    end
  end
end
