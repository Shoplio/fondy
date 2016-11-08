module Fondy
  class Signature
    def self.build(*args)
      new(*args).build
    end

    def self.verify(*args)
      new(*args).verify
    end

    def initialize(params:, password:)
      @params = params
      @password = password
    end

    def build
      filtered_params = params.reject do |k, v|
        %w(signature response_signature_string).include?(k.to_s) || v.to_s.empty?
      end
      params_str = filtered_params.sort_by(&:first).map(&:last).join('|')
      Digest::SHA1.hexdigest("#{password}|#{params_str}")
    end

    def verify
      unless params[:signature]
        raise Fondy::InvalidSignatureError, 'Response signature not found'
      end

      signature = build
      unless params[:signature] == signature
        raise Fondy::InvalidSignatureError, 'Invalid response signature'
      end

      true
    end

    private

    attr_reader :params
    attr_reader :password
  end
end
