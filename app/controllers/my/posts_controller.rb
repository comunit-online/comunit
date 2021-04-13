# frozen_string_literal: true

# User-side post handling
class My::PostsController < ProfileController
  include CrudEntities
  include ToggleableEntity

  before_action :set_entity, except: %i[check create index new]

  private

  def path_after_save
    @entity.world_url
  end

  def component_class
    Biovision::Components::PostsComponent
  end
end
