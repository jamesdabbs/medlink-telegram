module Factories
  def build klass, **opts
    builder = {
      User   => :build_user,
      Supply => :build_supply
    }[klass]

    if builder
      send builder, **opts
    else
      raise "Factory not registered: #{klass}"
    end
  end

  def build_supply name: nil, shortcode: nil
    instance_double Supply,
      name:      name      || rand.to_s,
      shortcode: shortcode || rand.to_s
  end

  def build_user name: nil, ordering: false
    instance_double User,
      name:      name || rand.to_s,
      ordering?: ordering
  end
end
