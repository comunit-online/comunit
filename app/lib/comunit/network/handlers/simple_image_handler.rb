# frozen_string_literal: true

module Comunit
  module Network
    module Handlers
      # Handling simple images
      class SimpleImageHandler < Comunit::Network::Handler
        def self.permitted_attributes
          super + %i[caption image image_alt_text source_link source_name]
        end

        def self.ignored_attributes
          %w[data id updated_at]
        end

        protected

        def pull_data
          apply_attributes
          apply_component
          bypass_carrierwave if data[:attributes].to_h.key?(:image)
          apply_image if site&.remote?
        end

        def relationships_for_remote
          {
            biovision_component: {
              data: {
                id: entity.biovision_component.slug,
                type: BiovisionComponent.table_name
              }
            }
          }
        end

        def apply_component
          slug = dig_related_id(:biovision_component)
          entity.biovision_component = BiovisionComponent[slug]
        end

        # Bypass carrierwave uploader when saving
        #
        # If site is local, we need only file name without additional processing
        # and the only found way to assign it without carrierwave is direct SQL
        # querying.
        def bypass_carrierwave
          log_info 'Bypassing carrierwave'

          image_name = data.dig(:attributes, :image).to_s
          if image_name.include?('/')
            log_error "Bad image name: #{image_name}"
            return
          end

          save_without_image if entity.id.nil?

          entity.update_columns(image: image_name)
        end

        def save_without_image
          log_info 'Saving without image attached'
          entity.valid?
          errors = entity.errors.messages

          # The only validation error should be blank image
          if errors.count > 1 || !errors.key?(:image)
            log_warn 'Wrong error count or key presence'
            return
          end

          entity.save(validate: false)
          entity.reload
        end
      end
    end
  end
end
