class ErrorsController < ApplicationController
  def error404
    if json_request?
      render json: {error: "not found", status: "failed"}, status: :not_found, callback: params[:callback]
    else
      render status: :not_found
    end
  end

  def error422
    if json_request?
      render json: {error: "unprocessable entity", status: "failed"}, status: :unprocessable_entity, callback: params[:callback]
    else
      render status: :unprocessable_entity
    end
  end

  def error500
    if json_request?
      render json: {error: "internal server error", status: "failed"}, status: :internal_server_error, callback: params[:callback]
    else
      render status: :internal_server_error
    end
  end

  private

  def json_request?
    env['ORIGINAL_FULLPATH'] =~ /\.json$/
  end
end