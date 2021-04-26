# frozen_string_literal: true

module Biovision
  module Components
    # Posts
    class PostsComponent < BaseComponent
      def self.dependent_models
        [Post, PostAttachment, PostImage, PostLink, PostReference, PostNote]
      end

      def administrative_parts
        %w[posts]
      end

      def use_images?
        true
      end

      def crud_table_names
        %w[posts]
      end
    end
  end
end
