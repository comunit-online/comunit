# frozen_string_literal: true

module Biovision
  module Components
    # Posts
    class PostsComponent < BaseComponent
      def self.dependent_models
        [
          Post, PostAttachment, PostImage, PostLink, PostReference, PostNote,
          PostGroup, PostGroupTaxon, PostTaxon, PostUser, Author
        ]
      end

      def administrative_parts
        [Post, PostGroup, Author].map(&:table_name)
      end

      def use_images?
        true
      end

      def use_files?
        true
      end

      def crud_table_names
        %w[posts post_groups simple_images uploaded_files]
      end
    end
  end
end
