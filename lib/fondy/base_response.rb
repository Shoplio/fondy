# frozen_string_literal: true
module Fondy
  class BaseResponse
    def initialize(http_response)
      @http_response = http_response
    end

    def success?
      raise NotImplementedError
    end

    def error?
      !success?
    end

    def error_code
      raise NotImplementedError
    end

    def error_message
      raise NotImplementedError
    end

    private

    def response
      @response ||= json_body[:response] || raise(Fondy::Error, 'Invalid response')
    end

    def json_body
      @json_body ||=
        begin
          JSON.parse(@http_response.body, symbolize_names: true)
        rescue
          raise Fondy::InvalidResponseError, 'Invalid response'
        end
    end
  end
end
