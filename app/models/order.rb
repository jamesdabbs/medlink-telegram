class Order
  attr_reader :supply, :placed_at

  def initialize hash
    @supply    = Supply.new hash.fetch "supply"
    @placed_at = hash.fetch "placed_at"
    freeze
  end
end
