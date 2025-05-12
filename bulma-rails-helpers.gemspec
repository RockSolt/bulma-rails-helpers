require_relative "lib/bulma/version"

Gem::Specification.new do |spec|
  spec.name        = "bulma-rails-helpers"
  spec.version     = Bulma::VERSION
  spec.authors     = [ "Todd Kummer" ]
  spec.email       = [ "todd@rockridgesolutions.com" ]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of Bulma::Rails::Helpers."
  spec.description = "TODO: Description of Bulma::Rails::Helpers."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["lib/**/*", "app/**/*", "config/importmap.rb"]

  spec.add_dependency "rails", ">= 8.0.2"
end
