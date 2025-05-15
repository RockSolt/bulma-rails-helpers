require_relative "lib/bulma/version"

Gem::Specification.new do |spec|
  spec.name        = "bulma-rails-helpers"
  spec.version     = Bulma::VERSION
  spec.authors     = [ "Todd Kummer" ]
  spec.email       = [ "todd@rockridgesolutions.com" ]
  spec.homepage    = "https://github.com/RockSolt/bulma-rails-helpers"
  spec.summary     = "Build Rails forms with Bulma CSS framework."
  spec.description = "Override the Rails tag helpers to generate HTML that plays well with the Bulma CSS framework."
  spec.license     = "MIT"
  spec.required_ruby_version = '>= 3.4.0'

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir["lib/**/*", "app/**/*", "config/importmap.rb"]

  spec.add_dependency "rails", ">= 8.0.2"

  spec.add_development_dependency "minitest-difftastic"
end
