# frozen_string_literal: true
module Fondy
  class Response < BaseResponse
    def to_h
      response
    end

    def success?
      response[:response_status] == 'success'
    end

    def error_code
      response[:error_code]
    end

    def error_message
      response[:error_message]
    end

    def method_missing(method, *_args)
      response[method] || super
    end

    def respond_to_missing?(method, *_args)
      response.key?(method)
    end
  end
end
