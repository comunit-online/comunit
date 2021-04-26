# frozen_string_literal: true

# Taxon
#
# Attributes:
#   children_cache [Array<integer>]
#   created_at [DateTime]
#   data [jsonb]
#   name [string]
#   nav_text [string]
#   object_count [integer]
#   parent_id [integer], optional
#   parents_cache [string]
#   priority [integer]
#   simple_image_id [SimpleImage], optional
#   slug [string]
#   updated_at [DateTime]
#   uuid [uuid]
#   visible [boolean]
class Taxon < ApplicationRecord
  include BelongsToSite
  include Checkable
  include HasSimpleImage
  include HasUuid
  include NestedPriority
  include Toggleable
  include TreeStructure

  SLUG_LIMIT = 50

  toggleable :visible

  has_many :taxon_users, dependent: :delete_all

  validates_presence_of :name
  validates_uniqueness_of :slug, scope: :parent_id

  scope :visible, -> { where(visible: true) }
  scope :list_for_administration, ->(v = nil) { where(parent_id: v&.id).ordered_by_priority }

  # @param [Taxon] entity
  def self.siblings(entity)
    where(parent_id: entity&.parent_id)
  end

  def self.entity_parameters
    %i[name nav_text priority simple_image_id slug visible]
  end

  def self.creation_parameters
    entity_parameters + %i[parent_id]
  end

  def text_for_link
    nav_text.blank? ? name : nav_text
  end
end
