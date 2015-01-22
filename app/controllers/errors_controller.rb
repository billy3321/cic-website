class ErrorsController < ApplicationController
  def error404
    render status: :not_found
  end

  def error422
    render status: :unprocessable_entity
  end

  def error500
    render status: :internal_server_error
  end
end