# frozen_string_literal: true

module Comunit
  module Network
    module Handlers
      # Handling posts
      class PostHandler < Comunit::Network::Handler
        def self.permitted_attributes
          super + %i[
            body lead publication_time source_name source_link title video
          ]
        end

        protected

        def pull_data
          apply_attributes
          apply_agent
          apply_simple_image
        end
      end
    end
  end
end
