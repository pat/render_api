# frozen_string_literal: true

require_relative "base"

module RenderAPI
  module Clients
    class Jobs < Base
      def create(service_id, start_command:, plan_id: nil)
        body = { startCommand: start_command }
        body[:plan_id] = plan_id unless plan_id.nil?

        endpoint.post(
          "/services/#{service_id}/jobs", body: body
        )
      end

      def find(service_id, job_id)
        endpoint.get(
          "/services/#{service_id}/jobs/#{job_id}"
        )
      end

      def list(service_id, ...)
        endpoint.get(
          "/services/#{service_id}/jobs", params: list_parameters(...)
        )
      end
    end
  end
end
