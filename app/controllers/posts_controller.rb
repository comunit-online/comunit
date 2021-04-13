# frozen_string_literal: true

# Public part of posts component
class PostsController < ApplicationController
  # get /posts
  def index
    @collection = Post.page_for_visitors(current_page)
  end

  # get /posts/:id-:slug
  def show
    @entity = Post.list_for_visitors.find_by(id: params[:id])
    handle_http_404 if @entity.nil?
  end
end
