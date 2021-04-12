# frozen_string_literal: true

# Link between posts
#
# Attributes:
#   data [jsonb]
#   other_post_id [Post]
#   post_id [Post]
#   priority [integer]
#   uuid [uuid]
class PostLink < ApplicationRecord
  include BelongsToSite
  include Checkable
  include HasUuid
  include NestedPriority

  belongs_to :post
  belongs_to :other_post, class_name: Post.to_s

  validates_uniqueness_of :other_post_id, scope: :post_id

  scope :list_for_visitors, -> { ordered_by_priority }
  scope :list_for_administration, -> { ordered_by_priority }

  # @param [PostLink] entity
  def self.siblings(entity)
    where(post_id: entity&.post_id)
  end

  def self.entity_parameters
    %i[priority]
  end

  def self.creation_parameters
    %i[other_post_id priority post_id]
  end
end
