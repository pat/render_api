# frozen_string_literal: true

require_relative "./data_object"

module RenderAPI
  class Response
    include Enumerable

    def initialize(http_response)
      @http_response = http_response
    end

    def data
      @data ||= http_response.parse(:json)
    end

    def each(&block)
      data_objects.each(&block)
    end

    def headers
      @headers ||= http_response.headers.to_h
    end

    def length
      data_objects.length
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

    def data_object(hash)
      DataObject.new(hash)
    end

    def data_objects
      @data_objects ||=
        case data
        when Array
          data.collect { |hash| data_object(hash) }
        else
          [data_object(data)]
        end
    end

    def method_missing(name, *args, **kwargs, &block)
      return super unless respond_to_missing?(name, false)

      data_objects.first.public_send(name, *args, **kwargs, &block)
    end

    def respond_to_missing?(name, include_all)
      return false if data.is_a?(Array)

      data_objects.first.respond_to?(name, include_all)
    end
  end
end
