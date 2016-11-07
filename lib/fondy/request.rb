module Fondy
  class Request
    API_HOST = 'https://api.fondy.eu'.freeze

    def self.call(*args)
      new(*args).call
    end

    def initialize(method, url, body)
      @method = method
      @url = url
      @body = body
    end

    def call
      connection = Faraday::Connection.new(API_HOST)
      connection.public_send(method) do |request|
        request.url url
        if body
          request.body = { request: body }.to_json
          request.headers['Content-Type'] = 'application/json'
        end
      end
    rescue Faraday::Error => e
      raise Fondy::RequestError, e.message
    end

    private

    attr_reader :method
    attr_reader :url
    attr_reader :body
  end
end
