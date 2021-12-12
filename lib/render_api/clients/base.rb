# frozen_string_literal: true

module RenderAPI
  module Clients
    class Base
      def initialize(endpoint)
        @endpoint = endpoint
      end

      private

      attr_reader :endpoint

      def filter_parameter(value)
        case value
        when Array
          value.join(",")
        else
          value.to_s
        end
      end

      def list_parameters(limit: nil, cursor: nil, filters: nil)
        parameters = {}
        filters ||= {}

        parameters[:limit] = limit unless limit.nil?
        parameters[:cursor] = cursor unless cursor.nil?

        filters.each do |key, value|
          parameters[key] = filter_parameter(value)
        end

        parameters
      end
    end
  end
end
