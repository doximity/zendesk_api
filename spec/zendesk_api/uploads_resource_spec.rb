require 'spec_helper'

describe ZendeskApi::UploadsResource do
  let(:client) { ZendeskApi::Client.build do |c|
    c.host = 'test.zendesk'
    c.username = 'foo'
    c.token = 'bar'
  end }
  let(:uploads) { ZendeskApi::UploadsResource.new(client) }

  describe "#create" do
    it "posts the upload_data to zendesk" do
      stub_request(:post, "https://foo%2Ftoken:bar@test.zendesk/api/v2/uploads.json?filename=foo.txt")
        .with(body: "foo")
        .to_return(:status => 200, :body => "{\"upload\":{\"token\":\"helloWorld\"}}", :headers => {'Content-Type'=>'text/json'})
      result = uploads.create({upload_data: 'foo', filename: 'foo.txt'})
      result.must_equal("token"=>"helloWorld")
    end

    it "raises an error when `filename` param is missing" do
      exception = ZendeskApi::UploadsResource::InvalidParameters
      error = ->{ uploads.create({upload_data: 'foo'}) }.must_raise exception
      error.message.must_match(/filename & upload_data are required params/)
    end

    it "raises an error when `upload_data` param is missing" do
      exception = ZendeskApi::UploadsResource::InvalidParameters
      error = ->{ uploads.create({filename: 'foo'}) }.must_raise exception
      error.message.must_match(/filename & upload_data are required params/)
    end
  end

  it "raises an error for update" do
    exception = ZendeskApi::UploadsResource::InvalidMethod
    err = ->{ uploads.update(42, {}) }.must_raise exception
    err.message.must_match(/update is not allowed on uploads/)
  end

  it "raises an error for show" do
    exception = ZendeskApi::UploadsResource::InvalidMethod
    err = ->{ uploads.show(42) }.must_raise exception
    err.message.must_match(/show is not allowed on uploads/)
  end

  it "raises an error for list" do
    exception = ZendeskApi::UploadsResource::InvalidMethod
    err = ->{ uploads.list }.must_raise exception
    err.message.must_match(/list is not allowed on uploads/)
  end
end
