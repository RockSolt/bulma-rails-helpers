require "rails/engine"

module Bulma
  class Engine < ::Rails::Engine
    initializer "bulma.importmap", before: "importmap" do |app|
      app.config.importmap.paths << Engine.root.join("config/importmap.rb")
    end

    initializer "bulma.assets" do |app|
      app.config.assets.paths << root.join("app/javascript")
    end
  end
end
