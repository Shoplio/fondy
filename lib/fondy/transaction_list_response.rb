module Fondy
  class TransactionListResponse < Response
    def transactions
      if response.is_a?(Array)
        response
      else
        []
      end
    end

    def success?
      response.is_a?(Array)
    end

    def error_code
      response[:error_code] if response.is_a?(Hash)
    end

    def error_message
      response[:error_message] if response.is_a?(Hash)
    end

    def method_missing(method, *_args)
      super
    end

    def respond_to_missing?(method, *_args)
      false
    end
  end
end
