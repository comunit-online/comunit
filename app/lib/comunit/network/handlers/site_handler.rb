# frozen_string_literal: true

module Comunit
  module Network
    module Handlers
      # Handling sites
      class SiteHandler < Comunit::Network::Handler
        def self.ignored_attributes
          super + %w[token]
        end

        def self.permitted_attributes
          super + %i[active host local name version]
        end

        def relationships_for_remote
          {
            simple_image: SimpleImageHandler.relationship_data(entity.simple_image)
          }
        end
      end
    end
  end
end
