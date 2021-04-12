# frozen_string_literal: true

# Post attachment
#
# Attributes:
#   attachment [string]
#   data [jsonb]
#   name [string], optional
#   post_id [Post]
#   uuid [uuid]
#   visible [boolean]
class PostAttachment < ApplicationRecord
  include BelongsToSite
  include Checkable
  include HasUuid
  include Toggleable

  NAME_LIMIT = 120

  toggleable :visible
  mount_uploader :file, SimpleFileUploader

  belongs_to :post

  validates_length_of :name, maximum: NAME_LIMIT
  validates_presence_of :file

  scope :ordered_for_list, -> { order('name asc, file asc') }
  scope :list_for_administration, -> { ordered_for_list }

  def self.entity_parameters
    %i[file name]
  end

  def name!
    return '' if file.blank?

    name.blank? ? CGI.unescape(File.basename(file.path)) : name
  end

  def size
    return 0 if file.blank?

    File.size(file.path)
  end
end
