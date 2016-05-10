class Medlink
  def self.for_phone phone
    new(
      phone: phone,
      token: Figaro.env.medlink_token!,
      url:   Figaro.env.medlink_url!
    )
  end

  def initialize phone: nil, token: nil, url: nil, runner: nil
    @phone, @runner = phone, runner
    @token = token || Figaro.env.medlink_token!
    @url   = url   || Figaro.env.medlink_url || "https://pcmedlink.org/api/v1"
    authorize_from_phone_number! if phone
  end

  def authorized?
    @auth.present?
  end

  def available_supplies
    request(:get, "/supplies")["supplies"].map { |d| Supply.new d }
  end

  def new_order supplies:
    request(:post, "/requests", body: {
      supply_ids: supplies.map(&:id)
    })
  end

  def outstanding_orders
    request(:get, "/orders")["orders"].map { |d| Order.new d }
  end

  private

  attr_reader :phone, :token, :url

  def authorize_from_phone_number!
    auth = request :post, "/auth/phone", body: {
      number: phone,
      token:  token
    }
    # TODO: what if this fails?
    @id, @auth = auth["id"], auth["secret_key"]
  end

  def request method, endpoint, body: nil
    opts = {
      url:     "#@url#{endpoint}",
      headers: { "Content-Type" => "application/json" },
      method:  method
    }
    opts[:payload] = body.to_json if body

    req = RestClient::Request.new opts
    req = ApiAuth.sign! req, @id, @auth if @auth
    JSON.parse(run req)
  end

  def run request
    @runner ? @runner.call(request) : request.execute
  end
end
