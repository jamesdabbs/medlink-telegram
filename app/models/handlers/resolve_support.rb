module Handlers
  class ResolveSupport < Handler
    def call c, user_id:
      user = User.find user_id
      user.has_been_helped!

      c.reply "Awesome, thanks for helping out!"
    end
  end
end
