require 'spec_helper'

describe ZendeskApi::Client do
  let(:client) { ZendeskApi::Client.build do |c|
    c.host = 'test.zendesk'
    c.username = 'foo'
    c.token = 'bar'
  end }

  it "responds to tickets" do
    client.tickets.must_be_kind_of ZendeskApi::TicketsResource
  end

  it "responds to search" do
    client.search.must_be_kind_of ZendeskApi::SearchResource
  end

  it "responds to ticket_fields" do
    client.ticket_fields.must_be_kind_of ZendeskApi::TicketFieldsResource
  end

  it "responds to uploads" do
    client.uploads.must_be_kind_of ZendeskApi::UploadsResource
  end
end
