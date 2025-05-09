require "rails/engine"

module Bulma
  class Engine < ::Rails::Engine
    initializer "bulma.assets" do |app|
      app.config.assets.paths << root.join("app/javascript")
    end
  end
end
