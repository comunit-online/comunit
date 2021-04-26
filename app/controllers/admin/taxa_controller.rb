# frozen_string_literal: true

# Handling taxa
class Admin::TaxaController < AdminController
  include CrudEntities
  include ToggleableEntity

  before_action :set_entity, except: %i[check create index new search]

  def search
    q = param_from_request(:q)
    @collection = Taxon.seacrh(q).ordered_by_name.page(current_page)
  end

  private

  def component_class
    Biovision::Components::TaxonomyComponent
  end
end
