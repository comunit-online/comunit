# frozen_string_literal: true

# Post author
# 
# Attributes:
#   about [text]
#   name [string]
#   patronymic [string]
#   simple_image_id [SimpleImage], optional
#   surname [string]
#   title [string]
#   user_id [User], optional
#   visible [boolean]
class Author < ApplicationRecord
  include Checkable
  include HasSimpleImage
  include HasOwner
  include Toggleable

  NAME_LIMIT = 70
  TITLE_LIMIT = 250

  toggleable :visible

  belongs_to :user, optional: true

  validates_presence_of :name, :surname
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :patronymic, maximum: NAME_LIMIT
  validates_length_of :surname, maximum: NAME_LIMIT
  validates_length_of :title, maximum: TITLE_LIMIT

  scope :ordered_by_name, -> { order(:surname, :name, :patronymic)}
  scope :visible, -> { where(visible: true) }
  scope :list_for_visitors, -> { included_image.visible.ordered_by_name }
  scope :list_for_administration, -> { included_image.ordered_by_name }

  def self.entity_parameters
    %i[about name patronymic simple_image_id surname title user_id visible]
  end

  def full_name
    [surname, name, patronymic].reject(&:blank?).join(' ')
  end

  def text_for_link
    full_name
  end

  def world_url
    "/authors/#{id}-#{CGI::escape(full_name)}"
  end
end
