class ZendeskApi::TicketsResource < ZendeskApi::Resource
  def resource_name
    "ticket"
  end

  def show_many(ids)
    return [] if ids.empty?

    request(:get, "show_many", ids: ids.join(","))[collection_root_element]
  end
end
