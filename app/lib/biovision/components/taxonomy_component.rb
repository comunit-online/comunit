# frozen_string_literal: true

module Biovision
  module Components
    # Taxonomy for entities
    class TaxonomyComponent < BaseComponent
      def self.dependent_models
        [Taxon, TaxonComponent, TaxonUser]
      end

      def use_images?
        true
      end

      def crud_table_names
        [Taxon].map(&:table_name)
      end
    end
  end
end
