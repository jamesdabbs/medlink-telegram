class Supply
  attr_reader :id, :name, :shortcode

  def initialize hash
    @id        = hash.fetch "id"
    @name      = hash.fetch "name"
    @shortcode = hash.fetch "shortcode"
    freeze
  end
end
