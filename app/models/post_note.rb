# frozen_string_literal: true

# Footnote in post
#
# Attributes:
#   body [text]
#   data [jsonb]
#   post_id [Post]
#   priority [integer]
#   uuid [uuid]
class PostNote < ApplicationRecord
  include BelongsToSite
  include HasUuid
  include NestedPriority

  belongs_to :post

  BODY_LIMIT = 1000

  validates_presence_of :body
  validates_length_of :body, maximum: BODY_LIMIT

  scope :list_for_visitors, -> { ordered_by_priority }
  scope :list_for_administration, -> { ordered_by_priority }

  # @param [PostNote] entity
  def self.siblings(entity)
    where(post_id: entity&.post_id)
  end

  def self.entity_parameters
    %i[body priority]
  end

  def self.creation_parameters
    entity_parameters + %i[post_id]
  end
end
