# ZendeskApi

Provides an agnostic API to access Zendesk resources through their REST JSON API.

```ruby
zendesk = ZendeskApi::Client.build do |c|
  c.host = ENV["ZENDESK_API_HOST"]
  c.username = ENV["ZENDESK_API_USERNAME"]
  c.token = ENV["ZENDESK_API_TOKEN"]
  c.logger = ActiveSupport::Logger.new(STDOUT)
end
```

The client provides a convenient interface for available resources. `ZendeskApi::Resource` objects handle http requests to endpoints and work pretty much as a repository.

```ruby
zendesk.tickets.show(4269666) # GET /api/v2/tickets/4269666.json

zendesk.tickets.delete(9001) # DELETE /api/v2/tickets/9001.json

zendesk.ticket_fields.list # GET /api/v2/ticket_fields.json

zendesk.ticket_fields.create(title: "cost", type: "decimal") # POST /api/v2/ticket_fields.json {"ticket_field":{"title":"cost","type":"decimal"}}

zendesk.tickets.update(9001, {"assignee_id":99}) # PUT /api/v2/tickets/9001.json {"ticket":{"assignee_id":99}}
```

Besides basic HTTP verbs, some resources have special endpoints are also supported.

```ruby
zendesk.tickets.show_many([42, 69, 666]) # GET /api/v2/tickets/show_many.json?ids=42,69,666

zendesk.search.query("wrong photo") # GET /api/v2/search.json?query=wrong%20photo
```

Resources will return models that provide an interface to attributes, navigation and persistence.

```ruby
results = zendesk.search.query("broken logout", per_page: 4)
results.next_page # GET /api/v2/search.json?query=broken%20logout&per_page=4&page=2

results.tickets # GET /api/v2/tickets/show_many.json?ids=13,42,69,666

ticket = results.tickets.first
ticket.set(assignee_id: 99)
ticket.save!
```

Ticket fields (custom fields) are also nicely handled with a hash:

```ruby
custom_fields = {client_account_id: 80, auto_fix: true, retry_count: 0}
available = zendesk.ticket_fields.list
fields = ZendeskApi::KeyValTicketFieldsCollection.new(custom_fields, available)

zendesk.tickets.update(69, custom_fields: fields.to_id_value_hashes)
```

or with the model

```ruby
ticket = zendesk.tickets.show(9001)
ticket.set(custom_fields: {app_section: :home, device: :ios})
ticket.save!
```

## Installation

Add this line to your application's Gemfile:

    gem 'zendesk_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zendesk_api

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
