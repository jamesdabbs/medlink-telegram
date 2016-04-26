module Handlers
  class Settings < Handler
    def applies?
      message.text =~ /^\/?settings/i
    end

    def run
      reply "TODO: show settings message"
    end
  end
end
