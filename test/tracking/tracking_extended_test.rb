# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Tracking Extended Operations' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  # POST /v1/tracking/start and /v1/tracking/stop read carrier_code +
  # tracking_number from the URL query string, NOT the request body.
  # Previous test stubs matched on `body:` which silently passed because
  # WebMock doesn't validate that the upstream API accepts that shape —
  # in reality every live call returned BusinessRulesError. Stub on
  # `query:` so a regression to body-encoded params would now fail.
  it 'starts tracking with carrier_code + tracking_number in the query string' do
    stub = stub_request(:post, 'https://api.shipengine.com/v1/tracking/start')
           .with(query: { carrier_code: 'stamps_com', tracking_number: '9400111899223456' })
           .to_return(status: 204, body: {}.to_json)

    client.tracking.start('stamps_com', '9400111899223456')
    assert_requested(stub, times: 1)
  end

  it 'stops tracking with carrier_code + tracking_number in the query string' do
    stub = stub_request(:post, 'https://api.shipengine.com/v1/tracking/stop')
           .with(query: { carrier_code: 'stamps_com', tracking_number: '9400111899223456' })
           .to_return(status: 204, body: {}.to_json)

    client.tracking.stop('stamps_com', '9400111899223456')
    assert_requested(stub, times: 1)
  end
end
