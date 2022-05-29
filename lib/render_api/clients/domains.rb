# frozen_string_literal: true

require_relative "./base"

module RenderAPI
  module Clients
    class Domains < Base
      def create(service_id, name:)
        endpoint.post(
          "/services/#{service_id}/custom-domains", body: { name: name }
        )
      end

      def delete(service_id, domain_id)
        endpoint.delete(
          "/services/#{service_id}/custom-domains/#{domain_id}"
        )
      end

      def find(service_id, domain_id)
        endpoint.get(
          "/services/#{service_id}/custom-domains/#{domain_id}"
        )
      end

      def list(service_id, ...)
        endpoint.get(
          "/services/#{service_id}/custom-domains", params: list_parameters(...)
        )
      end

      def verify(service_id, domain_id)
        endpoint.post(
          "/services/#{service_id}/custom-domains/#{domain_id}/verify"
        )
      end
    end
  end
end
