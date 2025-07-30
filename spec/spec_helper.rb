# frozen_string_literal: true

require "render_api"

require_relative "support/webmock"

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
