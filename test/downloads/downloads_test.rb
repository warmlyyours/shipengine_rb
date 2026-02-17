# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Downloads' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'downloads a file by subpath' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/downloads/labels/123/4')
           .to_return(status: 200, body: {
             url: 'https://cdn.shipengine.com/labels/123/4.pdf',
             content_type: 'application/pdf'
           }.to_json)

    response = client.downloads.download('labels/123/4')
    assert_equal 'https://cdn.shipengine.com/labels/123/4.pdf', response[:url]
    assert_requested(stub, times: 1)
  end
end
