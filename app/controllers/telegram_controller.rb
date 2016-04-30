class TelegramController < ApplicationController
  def receive
    if params[:token] != Figaro.env.telegram_token!
      head 400
    else
      # N.B. We're trusting the round-trip through the Update type
      #   to sanitize params for us
      data   = JSON.parse params[:telegram].to_json
      update = Telegram::Bot::Types::Update.new data
      Medbot.receive update: update
      render plain: "ok"
    end
  end
end
