# frozen_string_literal: true

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

    # Borrowed from awrence:
    # https://github.com/technicalpanda/awrence/blob/main/lib/awrence/methods.rb
    def camelize(string, first_upper: false)
      if first_upper
        string = gsubbed(string, /(?:^|_)([^_\s]+)/)
        gsubbed(string, %r{/([^/]*)}, "::")
      else
        parts = string.split("_", 2)
        parts[0] << camelize(parts[1], first_upper: true) if parts.size > 1
        parts[0] || ""
      end
    end

    # Borrowed and simplified from awrence:
    # https://github.com/technicalpanda/awrence/blob/main/lib/awrence/methods.rb
    def gsubbed(str, pattern, extra = "")
      str.gsub(pattern) { extra + Regexp.last_match(1).capitalize }
    end

    def method_missing(name, *args, **kwargs, &block)
      return super unless respond_to_missing?(name, false)
      raise ArgumentError if args.any? || kwargs.any? || block

      translate(data[camelize(name.to_s)])
    end

    def respond_to_missing?(name, _include_all)
      data.key?(camelize(name.to_s))
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
