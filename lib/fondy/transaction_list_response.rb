module Fondy
  class TransactionListResponse < BaseResponse
    def transactions
      success? ? response : []
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
  end
end
