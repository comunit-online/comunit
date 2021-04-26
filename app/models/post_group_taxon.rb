# frozen_string_literal: true

# Taxon in post group
#
# Attributes:
#   data [JSONb]
#   post_group_id [PostGroup]
#   taxon_id [Taxon]
class PostGroupTaxon < ApplicationRecord
  belongs_to :post_group
  belongs_to :taxon

  validates_uniqueness_of :taxon_id, scope: :post_group_id
end
