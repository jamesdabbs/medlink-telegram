class SupportNotifier
  def initialize client=nil
    @client = client || Bot::Client.build
  end

  def call user, buttons
    user.needs_help!
    client.message_support intro(user)
    client.message_support history(user), reply_markup: buttons
  end

  private

  attr_reader :client

  def intro user
    "#{user.name} (@#{user.telegram_username} / ##{user.id}) needs some help"
  end

  def history user
    "User history goes here ..."
  end
end
