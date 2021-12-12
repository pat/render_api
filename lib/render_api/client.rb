# frozen_string_literal: true

require_relative "./clients/deploys"
require_relative "./clients/services"
require_relative "./endpoint"

module RenderAPI
  class Client
    def initialize(api_key)
      @api_key = api_key
    end

    def deploys
      @deploys ||= Clients::Deploys.new(endpoint)
    end

    def services
      @services ||= Clients::Services.new(endpoint)
    end

    private

    attr_reader :api_key

    def endpoint
      @endpoint = Endpoint.new(api_key)
    end
  end
end
