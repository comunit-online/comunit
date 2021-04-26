# frozen_string_literal: true

# Post group
#
# Attributes:
#   name [string]
#   nav_text [string]
#   priority [integer]
#   slug [string]
#   visible [boolean]
class PostGroup < ApplicationRecord
  include Checkable
  include FlatPriority
  include RequiredUniqueSlug
  include RequiredUniqueName
  include Toggleable

  NAME_LIMIT = 50
  SLUG_PATTERN = /\A[a-z0-9][_a-z0-9]{,30}[a-z0-9]\z/i
  SLUG_PATTERN_HTML = '^[a-zA-Z0-9][_a-zA-Z0-9]{,30}[a-zA-Z0-9]$'

  toggleable :visible

  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :nav_text, maximum: NAME_LIMIT
  validates_format_of :slug, with: SLUG_PATTERN

  scope :visible, -> { where(visible: true) }
  scope :list_for_administration, -> { ordered_by_slug }

  # @param [String] slug
  def self.[](slug)
    visible.find_by(slug: slug)
  end

  def self.entity_parameters
    %i[name nav_text priority slug visible]
  end

  def text_for_link
    nav_text.blank? ? name : nav_text
  end
end
