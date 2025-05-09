module Bulma
  module Rails
    module Helpers
      class Engine < ::Rails::Engine
        isolate_namespace Bulma::Rails::Helpers
      end
    end
  end
end
