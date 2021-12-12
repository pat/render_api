# frozen_string_literal: true

module RenderAPI
  class Response
    def initialize(http_response)
      @http_response = http_response
    end

    def data
      @data ||= http_response.parse(:json)
    end

    def headers
      @headers ||= http_response.headers.to_h
    end

    def rate_limit
      headers["Ratelimit-Limit"].to_i
    end

    def rate_limit_remaining
      headers["Ratelimit-Remaining"].to_i
    end

    def rate_limit_reset
      headers["Ratelimit-Reset"].to_i
    end

    private

    attr_reader :http_response
  end
end
