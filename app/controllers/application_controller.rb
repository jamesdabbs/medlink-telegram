class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  rescue_from Dry::Types::StructError do |e|
    render json: { error: e.message }, status: 422
  end
end
