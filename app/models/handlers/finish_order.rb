module Handlers
  class FinishOrder < Handler
    match /^done$/i

    run do
      user.update! ordering: false
      reply "Cool, got it!"
    end
  end
end
