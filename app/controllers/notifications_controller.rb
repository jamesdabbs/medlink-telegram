class NotificationsController < ApplicationController
  before_action :check_token

  def response_created
    MedlinkTelegram.bot.callback :response_created,
      user:     User.find(params[:user_id]),
      response: Medlink::Response.from_params(params.require :response)
    head :ok
  end

  def check_delivery
    MedlinkTelegram.bot.callback :check_delivery,
      user:     User.find(params[:user_id]),
      response: Medlink::Response.from_params(params.require :response)
    head :ok
  end

  private

  def check_token
    unless Rack::Utils.secure_compare params[:token], ENV["medlink_token"]
      render plain: "Invalid token", status: 401
    end
  end
end
