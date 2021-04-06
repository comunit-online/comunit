# frozen_string_literal: true

module Comunit
  module Network
    module Handlers
      # Handling users
      class UserHandler < Comunit::Network::Handler
        def self.permitted_attributes
          super + %i[
            birthday bot email email_confirmed language_id notice
            password_digest phone phone_confirmed profile referral_link
            screen_name slug super_user updated_at
          ]
        end

        def self.meta_flags
          [
            Biovision::Components::UsersComponent::SETTING_EMAIL_AS_LOGIN,
            Biovision::Components::UsersComponent::SETTING_PHONE_AS_LOGIN,
            User::FLAG_SKIP_SCREEN_NAME
          ]
        end

        protected

        def pull_data
          apply_attributes
          apply_data_flags
          apply_agent
          apply_image
        end

        def apply_data_flags
          self.class.meta_flags.each do |flag|
            entity.data[flag] = data.dig(:meta, flag)
          end
        end

        def meta_flags_for_remote
          meta = {}
          self.class.meta_flags.each do |flag|
            meta[flag] = entity.data[flag]
          end
          meta
        end

        def meta_for_remote
          super.merge(meta_flags_for_remote)
        end
      end
    end
  end
end
