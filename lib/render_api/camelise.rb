# frozen_string_literal: true

module RenderAPI
  # Borrowed from awrence:
  # https://github.com/technicalpanda/awrence/blob/main/lib/awrence/methods.rb
  class Camelise
    def self.call(...)
      new.call(...)
    end

    def call(string, first_upper: false)
      if first_upper
        string = gsubbed(string, /(?:^|_)([^_\s]+)/)
        gsubbed(string, %r{/([^/]*)}, "::")
      else
        parts = string.split("_", 2)
        parts[0] << call(parts[1], first_upper: true) if parts.size > 1
        parts[0] || ""
      end
    end

    private

    def gsubbed(string, pattern, extra = "")
      string.gsub(pattern) { extra + Regexp.last_match(1).capitalize }
    end
  end
end
