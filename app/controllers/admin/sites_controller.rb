# frozen_string_literal: true

# Handling sites
class Admin::SitesController < AdminController
  include CrudEntities
  include ToggleableEntity

  before_action :set_entity, except: %i[check create index new]

  private

  def component_class
    Biovision::Components::ComunitComponent
  end
end
