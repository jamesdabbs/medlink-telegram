namespace :webhook do
  task run: :environment do
    puts "Running"
    set_webhook ""
    Telegram::Bot::Client.run Figaro.env.telegram_token! do |b|
      b.listen { |message| Medbot.handle request: Bot::Request.new(message) }
    end
  end

  desc "Set the webhook url"
  task set: :environment do
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
      sleep 5
      set_webhook_url
    end

    exec "ngrok http 3000"
  end

  def get_ngrok_url
    response = HTTParty.get "http://localhost:4040"
    response.match(/(https:\/\/\w+\.ngrok\.io)/)[1]
  end

  def set_webhook url=nil
    token = Figaro.env.telegram_token!

    url.sub! /https?:\/\//, ''
    url = url.empty? ? nil : "https://#{url}/telegram/#{token}"

    resp  = HTTParty.post \
      "https://api.telegram.org/bot#{token}/setWebhook",
      body: { url: url }
    puts resp
  end
end
