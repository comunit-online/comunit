# frozen_string_literal: true

# Taxon available in component
#
# Attributes:
#   biovision_component_id [BiovisionComponent]
#   taxon_id [Taxon]
class TaxonComponent < ApplicationRecord
  belongs_to :taxon
  belongs_to :biovision_component

  validates_uniqueness_of :taxon_id, scope: :biovision_component_id
end
