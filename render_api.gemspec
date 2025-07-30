# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "render_api"
  spec.version = "0.1.0"
  spec.authors = ["Pat Allan"]
  spec.email = ["pat@freelancing-gods.com"]

  spec.summary = "Ruby interface for the render.com API."
  spec.homepage = "https://github.com/pat/render_api"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/**/*"] + %w[LICENSE.txt README.md CHANGELOG.md]

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |file| File.basename(file) }
  spec.require_paths = ["lib"]

  spec.add_dependency "http"
end
