# frozen_string_literal: true

# Reference in post
#
# Attributes:
#   authors [string], optional
#   data [jsonb]
#   post_id [Post]
#   priority [integer]
#   publishing_info [string], optional
#   title [string]
#   url [string], optional
#   uuid [uuid]
class PostReference < ApplicationRecord
  include BelongsToSite
  include HasUuid
  include NestedPriority

  belongs_to :post

  META_LIMIT = 255

  validates_presence_of :title
  validates_length_of :authors, maximum: META_LIMIT
  validates_length_of :publishning_info, maximum: META_LIMIT
  validates_length_of :title, maximum: META_LIMIT
  validates_length_of :url, maximum: META_LIMIT

  scope :list_for_visitors, -> { ordered_by_priority }
  scope :list_for_administration, -> { ordered_by_priority }

  # @param [PostNote] entity
  def self.siblings(entity)
    where(post_id: entity&.post_id)
  end

  def self.entity_parameters
    %i[authors priority publishing_info title url]
  end

  def self.creation_parameters
    entity_parameters + %i[post_id]
  end
end
