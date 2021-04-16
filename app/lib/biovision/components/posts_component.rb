# frozen_string_literal: true

module Biovision
  module Components
    # Posts
    class PostsComponent < BaseComponent
      def self.dependent_models
        [Post, PostAttachment, PostImage, PostLink, PostReference, PostNote]
      end
    end
  end
end
