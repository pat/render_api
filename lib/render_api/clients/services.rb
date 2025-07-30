# frozen_string_literal: true

require_relative "base"

module RenderAPI
  module Clients
    class Services < Base
      def create(**payload)
        endpoint.post("/services", body: payload)
      end

      def delete(service_id)
        endpoint.delete("/services/#{service_id}")
      end

      def find(service_id)
        endpoint.get("/services/#{service_id}")
      end

      def list(...)
        endpoint.get("/services", params: list_parameters(...))
      end

      def list_headers(service_id, ...)
        endpoint.get(
          "/services/#{service_id}/headers", params: list_parameters(...)
        )
      end

      def list_routes(service_id, ...)
        endpoint.get(
          "/services/#{service_id}/routes", params: list_parameters(...)
        )
      end

      def list_variables(service_id, ...)
        endpoint.get(
          "/services/#{service_id}/env-vars", params: list_parameters(...)
        )
      end

      def resume(service_id)
        endpoint.post("/services/#{service_id}/resume")
      end

      def restart(service_id)
        endpoint.post("/services/#{service_id}/restart")
      end

      def scale(service_id, num_instances:)
        endpoint.post(
          "/services/#{service_id}/scale",
          body: { num_instances: num_instances }
        )
      end

      def suspend(service_id)
        endpoint.post("/services/#{service_id}/suspend")
      end

      def update(service_id, **payload)
        endpoint.patch("/services/#{service_id}", body: payload)
      end

      def update_variables(service_id, payloads)
        endpoint.put("/services/#{service_id}/env-vars", body: payloads)
      end
    end
  end
end
