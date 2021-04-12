# frozen_string_literal: true

# Image in post gallery
#
# Attributes:
#   data [jsonb]
#   description [text], optional
#   post_id [Post]
#   priority [integer]
#   simple_image_id [SimpleImage]
#   uuid [uuid]
#   visible [boolean]
class PostImage < ApplicationRecord
  include BelongsToSite
  include Checkable
  include HasSimpleImage
  include HasUuid
  include NestedPriority

  DESCRIPTION_LIMIT = 5000

  belongs_to :post

  validates_length_of :description, maximum: DESCRIPTION_LIMIT

  scope :visible, -> { where(visible: true) }
  scope :list_for_visitors, -> { visible.included_image.ordered_by_priority }
  scope :list_for_administration, -> { included_image.ordered_by_priority }

  def self.entity_parameters
    %i[description priority simple_image_id visible]
  end

  def self.creation_parameters
    entity_parameters + %i[post_id]
  end

  # @param [PostImage] entity
  def self.siblings(entity)
    where(post_id: entity&.post_id)
  end

  def text_for_link
    simple_image&.text_for_link
  end
end
