# frozen_string_literal: true

# Authors for visitors
class AuthorsController < ApplicationController
  # get /authors
  def index
    @collection = Author.list_for_administration
  end

  # get /authors/:id
  def show
    author_id = params[:id].split('-').first.to_i
    @entity = Author.list_for_visitors.find_by(id: author_id)
    handle_http_404 if @entity.nil?
    @collection = Post.owned_by(@entity&.user).page_for_visitors(current_page)
  end

  private

  def component_class
    Biovision::Components::PostsComponent
  end
end
