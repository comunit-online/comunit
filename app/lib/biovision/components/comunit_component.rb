# frozen_string_literal: true

module Biovision
  module Components
    # Comunit network
    class ComunitComponent < BaseComponent
      SETTING_MAIN_HOST = 'main_host'

      def self.settings_strings
        [SETTING_MAIN_HOST]
      end

      # @param [User] user
      def self.handle_new_user(user)
        ::Comunit::Network::Handler.sync(user)
      end

      def self.main_host
        self[nil].settings[SETTING_MAIN_HOST]
      end
    end
  end
end
