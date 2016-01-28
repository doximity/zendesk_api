require "net/http"
require "json"
require "uri"

module ZendeskApi
  class UploadsResource < ZendeskApi::Resource
    InvalidParameters = Class.new(ZendeskApi::Error)
    InvalidMethod = Class.new(ZendeskApi::Error)

    def create(params)
      unless valid_create_params?(params)
        raise InvalidParameters, "filename & upload_data are required params"
      end

      upload_data = params.delete(:upload_data)
      url = build_url("", params)
      request = Net::HTTP::Post.new(url)
      request.body = upload_data
      request.content_type = "application/octet-stream"
      processed_response(@api.auth_request(request))[root_element]
    end

    def update(id, params)
      raise InvalidMethod, "update is not allowed on uploads"
    end

    def show(id)
      raise InvalidMethod, "show is not allowed on uploads"
    end

    def list(params={})
      raise InvalidMethod, "list is not allowed on uploads"
    end

    def valid_create_params?(params)
      params.has_key?(:upload_data) &&
        params.has_key?(:filename)
    end

    def resource_name
      'upload'
    end
  end
end

