# frozen_string_literal: true

require_relative "./render_api/client"

module RenderAPI
  Error = Class.new(StandardError)

  def self.client(api_key)
    RenderAPI::Client.new(api_key)
  end
end
