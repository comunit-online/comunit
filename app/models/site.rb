# frozen_string_literal: true

# Network site
# 
# Attributes:
#   active [boolean]
#   created_at [DateTime]
#   data [jsonb]
#   host [string]
#   local [boolean]
#   name [string]
#   simple_image_id [SimpleImage]
#   token [string]
#   updated_at [DateTime]
#   uuid [uuid]
#   version [integer]
class Site < ApplicationRecord
  include Checkable
  include HasSimpleImage
  include HasUuid
  include RequiredUniqueName
  include Toggleable

  HOST_LIMIT = 100
  NAME_LIMIT = 50

  toggleable :active, :local

  has_secure_token

  validates_presence_of :host, :version
  validates_length_of :host, maximum: HOST_LIMIT
  validates_length_of :name, maximum: NAME_LIMIT
  validates_numericality_of :version, greater_than_or_equal_to: 0

  scope :active, -> { where(active: true) }
  scope :min_version, ->(v = 1) { where('version >= ?', v) }
  scope :list_for_visitors, -> { active.order('host asc') }
  scope :list_for_administration, -> { order('active desc, host asc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.entity_parameters
    %i[active host local name simple_image_id token version]
  end

  # @param [String] uuid
  def self.[](uuid)
    find_by(uuid: uuid)
  end

  def signature
    "#{id}:#{token}"
  end

  def text_for_link
    host
  end

  def world_url
    host
  end
end
