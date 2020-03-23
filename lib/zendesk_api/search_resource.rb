class ZendeskApi::SearchResource < ZendeskApi::Resource
  MAX_RESULTS = 1_000

  PaginationError = Class.new(ZendeskApi::Error)

  class SearchResults
    def initialize(resource, hash)
      @resource = resource
      @hash = hash
    end

    def results
      @hash["results"]
    end

    def result_ids
      results.map { |h| h["id"] }
    end

    def tickets
      return @tickets if defined?(@tickets)

      @tickets = @resource.tickets.show_many(result_ids)
    end

    def next_page
      raise PaginationError, "next page not found" unless next_page?

      navigate(@hash["next_page"])
    end

    def previous_page
      raise PaginationError, "previous page not found" unless previous_page?

      navigate(@hash["previous_page"])
    end

    def next_page?
      next_page_url = @hash["next_page"]

      return false if next_page_url.blank?

      query_params = CGI.parse(URI.parse(next_page_url).query)
      next_page = query_params["page"].first.to_i
      per_page = query_params["per_page"]&.first&.to_i || 100

      next_page * per_page <= MAX_RESULTS
    end

    def previous_page?
      @hash["previous_page"].present?
    end

    def count
      @hash["count"]
    end

    private
    def navigate(url)
      uri = URI.parse(url)

      self.class.new(
        @resource,
        @resource.build_request(:get, uri.path + "?" + uri.query))
    end
  end

  def query(*args)
    query = args.first.is_a?(String) ? { query: args.first } : {}
    params = args.extract_options!

    resp = request(:get, params.merge(query))
    SearchResults.new(self, resp)
  end

  def resource_name
    "search"
  end

  def collection_root_element
    "results"
  end

  def resource_collection_name
    resource_name
  end

  def tickets
    @api.tickets
  end
end
