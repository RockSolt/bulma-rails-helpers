module Bulma
  module Rails
    module Helpers
      class ApplicationRecord < ActiveRecord::Base
        self.abstract_class = true
      end
    end
  end
end
