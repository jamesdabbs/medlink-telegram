module Handlers
  class FinishOrder < Handler
    match /^done$/i

    def run
      user.update! ordering: false
      reply "Cool, got it!"
      # TODO: send order to medlink
    end
  end
end
