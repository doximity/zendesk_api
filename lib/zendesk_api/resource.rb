class ZendeskApi::Resource
  ValidationError = Class.new(StandardError)

  def initialize(api)
    @api = api
  end

  def create(params)
    request(:post, resource_name => params)[resource_name]
  end

  def update(id, params)
    request(:put, id, resource_name => params)[resource_name]
  end

  def delete(id)
    request(:delete, id)
  end

  def show(id)
    request(:get, id)[resource_name]
  end

  def list(params = {})
    request(:get, params)[resource_collection_name]
  end

  protected
  def resource_name
    raise NotImplementedError
  end

  def resource_collection_name
    resource_name.pluralize
  end

  def request(method, *args)
    data = args.extract_options! || {}

    url_part = resource_collection_name
    if id = args.first
      url_part += "/#{id}"
    end

    uri = "/api/v2/#{url_part}.json"
    uri += "?#{data.to_param}" if method == :get

    req_class = "Net::HTTP::#{method.to_s.capitalize}".constantize
    req = req_class.new(uri)       
    req.body = data.present? && method != :get ? data.to_json : nil

    if method == :post
      @api.logger.debug("POST to ZendeskAPI #{uri} : \n#{req.body}\n\n")
    end

    req["Content-Type"] = "application/json"
    
    processed_response(@api.auth_request(req))
  end

  private
  def processed_response(resp)
    case resp
    when Net::HTTPCreated, Net::HTTPOK
      begin
        JSON.parse(resp.body)
      rescue JSON::ParserError
        true
      end
    when Net::HTTPUnprocessableEntity
      raise ValidationError, resp.body
    when Net::HTTPUnauthorized
      raise "Invalid credentials for ZendeskApi"
    else
      @api.logger.debug(resp)
      false
    end
  end

end
