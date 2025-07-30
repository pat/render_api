# frozen_string_literal: true

require_relative "camelise"

module RenderAPI
  class DataObject
    TIME_PATTERN = /\A\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d+Z\z/.freeze

    attr_reader :cursor

    def initialize(data)
      if data["cursor"]
        @cursor = data.delete("cursor")
        @data = data.values.first
      else
        @data = data
      end
    end

    def to_h
      data
    end

    private

    attr_reader :data

    def method_missing(name, *args, **kwargs, &block)
      return super unless respond_to_missing?(name, false)
      raise ArgumentError if args.any? || kwargs.any? || block

      translate(data[Camelise.call(name.to_s)])
    end

    def respond_to_missing?(name, _include_all)
      data.key?(Camelise.call(name.to_s))
    end

    def translate(object)
      case object
      when Hash
        self.class.new(object)
      when Array
        object.collect { |item| translate(item) }
      when String
        object[TIME_PATTERN] ? Time.parse(object) : object
      else
        object
      end
    end
  end
end
