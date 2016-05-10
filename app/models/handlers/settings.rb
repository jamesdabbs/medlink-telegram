module Handlers
  class Settings < Handler
    match /^\/?settings/i

    run do
      reply "TODO: show settings message"
    end
  end
end
