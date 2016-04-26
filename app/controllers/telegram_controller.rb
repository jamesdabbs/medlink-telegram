class TelegramController < ApplicationController
  B = Bot.new

  def receive
    if params[:token] != Figaro.env.telegram_token!
      head 400
    else
      update  = Telegram::Bot::Types::Update.new params[:telegram].permit!
      request = Bot::Request.new update.message || update.callback_query
      B.handle request
      render plain: "ok"
    end
  end
end
