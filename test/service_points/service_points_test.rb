# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Service Points' do
  after do
    WebMock.reset!
  end

  client = ShipEngine::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'lists service points' do
    params = { address_query: { postal_code: '78756', country_code: 'US' }, providers: [{ carrier_id: 'se-1' }] }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/service_points/list')
           .with(body: params.to_json)
           .to_return(status: 200, body: {
             service_points: [{ service_point_id: 'sp-1', carrier_code: 'ups' }]
           }.to_json)

    response = client.list_service_points(params)
    assert_equal 1, response['service_points'].length
    assert_requested(stub, times: 1)
  end

  it 'gets a service point by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/service_points/ups/US/sp-1')
           .to_return(status: 200, body: { service_point_id: 'sp-1', carrier_code: 'ups' }.to_json)

    response = client.get_service_point_by_id('ups', 'US', 'sp-1')
    assert_equal 'sp-1', response['service_point_id']
    assert_requested(stub, times: 1)
  end
end
