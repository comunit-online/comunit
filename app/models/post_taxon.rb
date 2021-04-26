# frozen_string_literal: true

# Taxon in post
#
# Attributes:
#   post_id [Post]
#   taxon_id [Taxon]
class PostTaxon < ApplicationRecord
  belongs_to :post
  belongs_to :taxon, counter_cache: :object_count

  validates_uniqueness_of :taxon_id, scope: :post_id
end
