# frozen_string_literal: true

# Handling post groups
class Admin::PostGroupsController < AdminController
  include CrudEntities
  include ToggleableEntity

  before_action :set_entity, except: %i[check create index new]

  private

  def component_class
    Biovision::Components::PostsComponent
  end
end
