module Fondy
  class Response
    def initialize(http_response)
      @http_response = http_response
    end

    def method_missing(method, *_args)
      response[method.to_s] || super
    end

    def respond_to_missing?(method, *_args)
      response.key?(method.to_s)
    end

    private

    def response
      @response ||= json_body['response'] || raise(Fondy::Error, 'Invalid response')
    end

    def json_body
      @json_body ||=
        begin
          JSON.parse(@http_response.body)
        rescue
          raise Fondy::Error, 'Invalid response'
        end
    end
  end
end
