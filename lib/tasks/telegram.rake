namespace :telegram do
  task poll: :environment do
    Rails.logger = Logger.new STDOUT
    Rails.logger.info "Polling for updates ..."

    set_webhook ""

    Telegram::Bot::Client.run Figaro.env.telegram_token! do |b|
      b.listen do |m|
        update = case m
                 when Telegram::Bot::Types::Message
                   Telegram::Bot::Types::Update.new message: m
                 when Telegram::Bot::Types::CallbackQuery
                   Telegram::Bot::Types::Update.new callback_query: m
                 end
        Medbot.receive update: update
      end
    end
  end

  desc "Set the webhook url"
  task webhook: :environment do
    require "httparty"

    unless url = get_ngrok_url
      print "Url: "
      url = $stdin.gets.chomp
    end

    set_webhook url
  end

  desc "Start ngrok and point the webhook at it"
  task ngrok: :environment do
    fork do
      Rails.logger.debug "Waiting ..."
      sleep 5
      set_webhook get_ngrok_url
    end

    exec "ngrok http 3000"
  end

  def get_ngrok_url
    response = `curl -s http://localhost:4040/inspect/http`
    response.match(/(https:\/\/\w+\.ngrok\.io)/)[1]
  end

  def set_webhook url=nil
    token = Figaro.env.telegram_token!

    url.sub! /https?:\/\//, ''
    url = url.empty? ? nil : "https://#{url}/telegram/#{token}"

    Rails.logger.debug "\n\rSetting webhook => #{url} => localhost:3000"
    resp = `curl -s -XPOST -d"url=#{url}" https://api.telegram.org/bot#{token}/setWebhook`
    Rails.logger.debug "\n\r#{resp}"
  end
end
