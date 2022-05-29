# frozen_string_literal: true

require "http"

require_relative "./response"

module RenderAPI
  class Endpoint
    HOST = "https://api.render.com"
    VERSION = "/v1"

    def initialize(api_key)
      @api_key = api_key
    end

    def get(path, params: nil)
      request(:get, path, params: params)
    end

    def post(path, body: nil)
      request(:post, path, body: body)
    end

    def delete(path)
      request(:delete, path)
    end

    private

    attr_reader :api_key

    def handle_error(response)
      raise RequestError, response.body.to_s
    end

    def http
      HTTP
        .auth("Bearer #{api_key}")
        .headers("Accept" => "application/json")
        .headers("Content-Type" => "application/json")
    end

    def request(verb, path, body: nil, params: nil)
      response = http.request(verb, url_for(path), json: body, params: params)
      handle_error(response) unless response.status.success?

      case response.status.code
      when 202, 204
        true
      else
        Response.new(response)
      end
    end

    def url_for(path)
      "#{HOST}#{VERSION}#{path}"
    end
  end
end
