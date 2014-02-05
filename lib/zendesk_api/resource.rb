require "net/http"
require "json"
require "uri"

class ZendeskApi::Resource
  ValidationError = Class.new(StandardError)

  def initialize(api)
    @api = api
  end

  def create(params)
    request(:post, resource_name => params)[root_element]
  end

  def update(id, params)
    request(:put, id, resource_name => params)[root_element]
  end

  def delete(id)
    request(:delete, id)
  end

  def show(id)
    request(:get, id)[root_element]
  end

  def list(params = {})
    request(:get, params)[collection_root_element]
  end

  def request(method, *args)
    data = args.extract_options! || {}
    path = args.first || ""
    uri = build_url(path, method == :get ? data : {})
    build_request(method, uri, data)
  end

  def build_url(path, data = {})
    path = "/#{path}" if path != ""
    resource_path = resource_collection_name

    uri = "/api/v2/#{resource_path}#{path}.json"

    unless data.empty?
      # TODO: find a replacemente for Rails' `.to_param`
      data_to_param = data.
        reduce("") { |m, kv| m << "#{kv[0]}=#{URI.encode(kv[1].to_s)}&" }
      uri += "?#{data_to_param}"
    end

    uri
  end

  def build_request(method, uri, data = nil)
    # TODO: find a replacement for Rails' `.constantize`
    req_class = "Net::HTTP::#{method.to_s.capitalize}".
      split("::").reduce(Object) { |m, c| m.const_get(c) }
    req = req_class.new(uri)       
    req.body = !data.nil? && method != :get ? data.to_json : nil

    @api.logger.debug(
      "#{method.to_s.upcase} to ZendeskAPI #{uri}" + 
      ([:post, :put].include?(method) ? " : \n#{req.body}\n\n" : ""))

    req["Content-Type"] = "application/json"
    
    processed_response(@api.auth_request(req))
  end

  protected
  def resource_name
    raise NotImplementedError
  end

  def resource_collection_name
    # TODO: find a replacement for Rails' `pluralize`
    resource_name + "s"
  end

  def root_element
    resource_name
  end

  def collection_root_element
    resource_collection_name
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
