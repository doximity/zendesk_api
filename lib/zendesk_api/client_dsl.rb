module ZendeskApi::ClientDsl
  def req(resource, method, *params)
    send(resource).
      send(method, *params)
  end

  def search
    ZendeskApi::SearchResource.new(self)
  end

  def tickets
    ZendeskApi::TicketsResource.new(self)
  end

  def ticket_fields
    ZendeskApi::TicketFieldsResource.new(self)
  end

  def uploads
    ZendeskApi::UploadsResource.new(self)
  end
end
