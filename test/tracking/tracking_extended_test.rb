# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Tracking Extended Operations' do
  after do
    WebMock.reset!
  end

  client = ShipEngine::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'starts tracking' do
    stub = stub_request(:post, 'https://api.shipengine.com/v1/tracking/start')
           .with(body: { carrier_code: 'stamps_com', tracking_number: '9400111899223456' }.to_json)
           .to_return(status: 204, body: {}.to_json)

    client.start_tracking('stamps_com', '9400111899223456')
    assert_requested(stub, times: 1)
  end

  it 'stops tracking' do
    stub = stub_request(:post, 'https://api.shipengine.com/v1/tracking/stop')
           .with(body: { carrier_code: 'stamps_com', tracking_number: '9400111899223456' }.to_json)
           .to_return(status: 204, body: {}.to_json)

    client.stop_tracking('stamps_com', '9400111899223456')
    assert_requested(stub, times: 1)
  end
end
