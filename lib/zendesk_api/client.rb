class ZendeskApi::Client
  class Config
    attr_accessor :token, :username, :host, :logger
  end

  def self.build(&block)
    new(block.call(Config.new))
  end

  def initialize(config)
    @config = config
  end

  def ping
    Resource.new(self).request("users/me", :get)
  end

  def auth_request(req)
    req.basic_auth("#{username}/token", token)
    http_client.request(req)
  end

  protected
  def token
    @config.token
  end

  def username
    @config.username
  end

  def host
    @config.host
  end

  def logger
    @config.logger
  end

  def http_client
    return @http_client if defined?(@http_client)

    @http_client = Net::HTTP.new(host, 443)
    @http_client.use_ssl = true
    @http_client
  end
end

