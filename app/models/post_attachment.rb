# frozen_string_literal: true

# Post attachment
#
# Attributes:
#   data [jsonb]
#   name [string], optional
#   post_id [Post]
#   uploaded_file_id [UploadedFile]
#   uuid [uuid]
#   visible [boolean]
class PostAttachment < ApplicationRecord
  include BelongsToSite
  include Checkable
  include HasUploadedFile
  include HasUuid
  include Toggleable

  NAME_LIMIT = 120

  toggleable :visible

  belongs_to :post

  validates_length_of :name, maximum: NAME_LIMIT

  scope :ordered_for_list, -> { order(:name) }
  scope :list_for_administration, -> { ordered_for_list }

  def self.entity_parameters
    %i[name uploaded_file_id]
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
