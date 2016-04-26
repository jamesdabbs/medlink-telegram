namespace :webhook do
  task run: :environment do
    puts "Running"
    Bot.run
  end

  desc "Set the webhook url"
  task set: :environment do
    require "httparty"
    token = Figaro.env.telegram_token!

    print "Url: "
    url = $stdin.gets.chomp
    url.sub! /https?:\/\//, ''
    url = url.empty? ? nil : "https://#{url}/telegram/#{token}"

    resp = HTTParty.post "https://api.telegram.org/bot#{token}/setWebhook", body: {
                           url: url
    }
    puts resp
  end
end
