# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Parse Address' do
  after do
    WebMock.reset!
  end

  client = ShipEngine::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'parses an address from text' do
    params = { text: 'I need to ship to 525 S Winchester Blvd, San Jose CA 95128' }

    stub = stub_request(:put, 'https://api.shipengine.com/v1/addresses/recognize')
           .with(body: params.to_json)
           .to_return(status: 200, body: {
             score: 0.97,
             address: {
               address_line1: '525 S Winchester Blvd',
               city_locality: 'San Jose',
               state_province: 'CA',
               postal_code: '95128',
               country_code: 'US'
             },
             entities: []
           }.to_json)

    response = client.parse_address(params)
    assert_equal '525 S Winchester Blvd', response['address']['address_line1']
    assert_equal 0.97, response['score']
    assert_requested(stub, times: 1)
  end
end
