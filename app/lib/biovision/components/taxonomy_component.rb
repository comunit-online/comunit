# frozen_string_literal: true

module Biovision
  module Components
    # Taxonomy for entities
    class TaxonomyComponent < BaseComponent
      def self.dependent_models
        [Taxon, TaxonUser]
      end

      def use_images?
        true
      end
    end
  end
end
