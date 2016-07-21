class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  rescue_from Dry::Types::StructError do |e|
    render json: { error: e.message }, status: 422
  end

  rescue_from ArgumentError do |e|
    # :nocov:
    # The container holds references that become out of date when the server auto-reloads in dev
    # It's a little too late to fix _this_ error, but we can reload the container manually for
    #   the next request
    if e.message =~ /A copy of \w+ has been removed from the module tree but is still active/
      Rails.application.config.container.reset!
    else
      raise e
    end
    # :nocov:
  end if Rails.env.development?
end
