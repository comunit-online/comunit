# frozen_string_literal: true

# Adds method for CRUD
module CrudEntities
  extend ActiveSupport::Concern
  include ProcessedForms

  # get [scope]/[table_name]
  def index
    @collection = if paginate_entities?
                    model_class.page_for_administration(current_page)
                  else
                    model_class.list_for_administration
                  end
  end

  # get [scope]/[table_name]/:id
  def show
  end

  # post [scope]/[table_name]/check
  def check
    @entity = model_class.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get [scope]/[table_name]/new
  def new
    @entity = model_class.new
    render view_for_new
  end

  # post [scope]/[table_name]
  def create
    @entity = model_class.new(creation_parameters)
    apply_meta if @entity.respond_to?(:meta=)
    if @entity.save
      Comunit::Network::Handler.sync(@entity)
      form_processed_ok(path_after_save)
    else
      form_processed_with_error(view_for_new)
    end
  end

  # get [scope]/[table_name]/:id/edit
  def edit
    render view_for_edit
  end

  # patch [scope]/[table_name]/:id
  def update
    apply_meta if @entity.respond_to?(:meta=)

    if @entity.update(entity_parameters)
      Comunit::Network::Handler.sync(@entity)
      form_processed_ok(path_after_save)
    else
      form_processed_with_error(view_for_edit)
    end
  end

  # delete [scope]/[table_name]/:id
  def destroy
    flash[:notice] = t('.success') if @entity.destroy
    redirect_to path_after_destroy
  end

  private

  def view_for_new
    default_view = "#{controller_path}/new"
    lookup_context.exists?(default_view) ? default_view : 'shared/entity/new'
  end

  def view_for_edit
    default_view = "#{controller_path}/edit"
    lookup_context.exists?(default_view) ? default_view : 'shared/entity/edit'
  end

  def model_class
    @model_class ||= controller_name.classify.constantize
  end

  def path_after_save
    scope = self.class.module_parent.to_s.downcase
    prefix = scope.blank? ? '' : "/#{scope}"
    "#{prefix}/#{model_class.table_name}/#{@entity.id}"
  end

  def path_after_destroy
    scope = self.class.module_parent.to_s.downcase
    prefix = scope.blank? ? '' : "/#{scope}"
    "#{prefix}/#{model_class.table_name}"
  end

  def paginate_entities?
    model_class.respond_to?(:page_for_administration)
  end

  def set_entity
    @entity = model_class.find_by(id: params[:id])
    handle_http_404("Cannot find #{model_class.model_name}") if @entity.nil?
  end

  def model_key
    model_class.model_name.to_s.underscore
  end

  def creation_parameters
    if model_class.respond_to?(:creation_parameters)
      explicit_creation_parameters
    else
      entity_parameters
    end
  end

  def explicit_creation_parameters
    permitted = model_class.creation_parameters
    parameters = params.require(model_key).permit(permitted)
    parameters.merge!(tracking_for_entity) if model_class.include?(HasTrack)
    parameters.merge!(owner_for_entity) if model_class.include?(HasOwner)
    parameters
  end

  def entity_parameters
    permitted = model_class.entity_parameters
    params.require(model_key).permit(permitted)
  end

  def apply_meta
    new_data = params[:meta].permit!
    @entity.meta = new_data
  end
end
