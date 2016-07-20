class OrderPlacer
  attr_reader :new_orders, :pre_existing_orders, :user_errors

  def initialize medlink:, user:
    @medlink, @user = medlink, user
    @new_orders, @pre_existing_orders, @user_errors = [], [], []
  end

  def run supplies
    medlink.new_order supplies, credentials: user.credentials
    new_orders.concat supplies
  end

  private

  attr_reader :medlink, :user
end
