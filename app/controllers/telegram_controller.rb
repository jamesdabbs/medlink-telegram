class TelegramController < ApplicationController
  def receive
    if MedlinkTelegram.bot.valid_token? params[:token]
      MedlinkTelegram.bot.receive \
        update: Medbot.update_from_telegram(params[:telegram])
    else
      head 400
    end
  end
end
