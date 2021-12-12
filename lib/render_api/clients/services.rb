# frozen_string_literal: true

require_relative "./base"

module RenderAPI
  module Clients
    class Services < Base
      def find(service_id)
        endpoint.get("/services/#{service_id}")
      end

      def list(...)
        endpoint.get("/services", params: list_parameters(...))
      end
    end
  end
end
