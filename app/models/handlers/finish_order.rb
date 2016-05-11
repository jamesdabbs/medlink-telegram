module Handlers
  class FinishOrder < Handler
    match /^done$/i

    def call c
      c.user.update! ordering: false
      c.reply "Cool, got it!"
    end
  end
end
