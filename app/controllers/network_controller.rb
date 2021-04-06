# frozen_string_literal: true

# Common parts for working with Comunit network
class NetworkController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_handler

  # get /comunit/:table_name/:uuid
  def show
    render json: @handler.show(params[:uuid])
  end

  # put /comunit/:table_name/:uuid
  def pull
    if @handler.pull(params[:uuid])
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  # post /comunit/:table_name/:uuid/rpc
  def rpc
    @handler.rpc
    head :no_content
  end

  protected

  def set_handler
    model_name = params[:table_name].classify
    prefix = 'Comunit::Network::Handlers::'
    handler_class = "#{prefix}#{model_name}Handler".safe_constantize
    if handler_class
      init_handler(handler_class)
    else
      render json: { errors: { handler: false } }, status: :unprocessable_entity
    end
  end

  # @param [Comunit::Network::Handler]
  def init_handler(handler_class)
    @handler = handler_class[request.headers['HTTP_SIGNATURE'].to_s]
    @handler.data = params.require(:data).permit!
  rescue Comunit::Network::Errors::UnknownSiteError
    error = t('network.signature.unknown_site')
    render json: { errors: { signature: error } }, status: :bad_request
  rescue Comunit::Network::Errors::InvalidSignatureError
    error = t('network.signature.invalid_signature')
    render json: { errors: { signature: error } }, status: :unauthorized
  end
end
