# frozen_string_literal: true

# Overriding administrative components controller
Admin::ComponentsController.class_eval do
  def create_image
    if @handler.allow?
      @entity = @handler.component.simple_images.new(image_parameters)
      if @entity.save
        Comunit::Network::Handler.sync(@entity)
        render 'image', formats: :json
      else
        form_processed_with_error(:new_image)
      end
    else
      handle_http_401('Uploading images is not allowed for current user')
    end
  end

  # post /admin/components/:slug/ckeditor
  def ckeditor
    parameters = {
      image: params[:upload],
      biovision_component: @handler.component
    }.merge(owner_for_entity(true))

    @entity = SimpleImage.create!(parameters)
    Comunit::Network::Handler.sync(@entity)

    render json: {
      uploaded: 1,
      fileName: File.basename(@entity.image.path),
      url: @entity.image.medium_url
    }
  end
end
