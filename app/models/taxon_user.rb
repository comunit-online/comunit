# frozen_string_literal: true

# Taxon available to user
#
# Attributes:
#   data [JSONb]
#   user_id [User]
#   taxon_id [Taxon]
class TaxonUser < ApplicationRecord
  include BelongsToSite
  include HasOwner

  belongs_to :taxon
  belongs_to :user

  validates_uniqueness_of :taxon_id, scope: :user_id
end
