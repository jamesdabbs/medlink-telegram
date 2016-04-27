namespace :webhook do
  task run: :environment do
    puts "Running"
    Bot.run
  end

  desc "Set the webhook url"
  task set: :environment do
    require "httparty"

    print "Url: "
    set_webhook $stdin.gets.chomp
  end

  desc "Start ngrok and point the webhook at it"
  task ngrok: :environment do
    fork do
      sleep 5
      response = HTTParty.get "http://localhost:4041"
      domain   = response.match(/(https:\/\/\w+\.ngrok\.io)/)[1]
      set_webhook domain
    end

    exec "ngrok http 3000"
  end

  def set_webhook url
    token = Figaro.env.telegram_token!

    url.sub! /https?:\/\//, ''
    url = url.empty? ? nil : "https://#{url}/telegram/#{token}"

    resp  = HTTParty.post \
      "https://api.telegram.org/bot#{token}/setWebhook",
      body: { url: url }
    puts resp
  end
end
