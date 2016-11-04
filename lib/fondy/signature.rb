module Fondy
  class Signature
    def self.build(*args)
      new(*args).build
    end

    def initialize(params:, password:)
      @params = params
      @password = password
    end

    def build
      filtered_params = params.reject { |k, _v| k.to_s == 'signature' }
      params_str = filtered_params.sort_by(&:first).map(&:last).join('|')
      Digest::SHA1.hexdigest("#{password}|#{params_str}")
    end

    private

    attr_reader :params
    attr_reader :password
  end
end
