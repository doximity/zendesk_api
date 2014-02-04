class ZendeskApi::Search < ZendeskApi::Resource
  def resource_name
    "search"
  end

  def resource_collection_name
    resource_name
  end
end

