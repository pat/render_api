# frozen_string_literal: true

require_relative "./base"

module RenderAPI
  module Clients
    class Services < Base
      def list(...)
        endpoint.get("/services", params: list_parameters(...))
      end
    end
  end
end
