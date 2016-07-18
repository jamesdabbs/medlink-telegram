module BaseHelpers
  def medlink
    @medlink ||= instance_double Medlink::User::Client
  end
end
