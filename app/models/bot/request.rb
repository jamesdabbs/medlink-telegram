class Bot
  class Request
    attr_reader :message
    attr_writer :user

    def initialize message, user: nil, medlink: nil
      @message, @user, @medlink = message, user, medlink
    end

    def user
      @user ||= User.find_by(telegram_id: message.from.id)
    end

    def medlink
      @medlink ||= Medlink.for_phone(user.phone_number)
    end
  end
end
