# frozen_string_literal: true

require "delegate"
require "webmock/rspec"

module WebmockJSONHelpers
  def stub_request(method, uri)
    RequestStub.new(super)
  end

  def a_request(method, uri)
    RequestPattern.new(super)
  end

  class RequestStub < SimpleDelegator
    def to_return_json(*response_hashes, &block)
      typed_hashes = response_hashes.map do |hash|
        typed = hash.dup

        typed[:headers] ||= {}
        typed[:headers]["Content-Type"] = "application/json"

        typed[:body] = JSON.dump(hash[:body] || {})

        typed
      end

      to_return(*typed_hashes, &block)
    end
  end

  class RequestPattern < SimpleDelegator
    def with_json_body
      with do |request|
        yield JSON.parse(request.body)
      end
    end
  end
end

RSpec.configure do |config|
  config.include WebmockJSONHelpers
end
