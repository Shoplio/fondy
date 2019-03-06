# frozen_string_literal: true
module Fondy
  class Error < StandardError
  end

  class RequestError < Error
  end

  class InvalidResponseError < Error
  end

  class InvalidSignatureError < Error
  end
end
