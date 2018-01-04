module Comunit
  module Local
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
