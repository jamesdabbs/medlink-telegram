module Handlers
  class Settings < Handler
    match /^\/?settings/i

    def call c
      c.reply "TODO: show settings message"
    end
  end
end
