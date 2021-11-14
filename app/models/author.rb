# frozen_string_literal: true

# Post author
# 
# Attributes:
#   about [text]
#   name [string]
#   patronymic [string]
#   title [string]
#   simple_image_id [SimpleImage], optional
#   surname [string]
#   user_id [User], optional
#   visible [boolean]
class Author < ApplicationRecord
  include Checkable
  include HasSimpleImage
  include HasOwner
  include Toggleable

  toggleable :visible

  belongs_to :user, optional: true
end
