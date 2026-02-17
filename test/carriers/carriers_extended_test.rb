# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Carriers Extended Operations' do
  after do
    WebMock.reset!
  end

  client = ShipEngine::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'gets a carrier by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/carriers/se-123')
           .to_return(status: 200, body: { carrier_id: 'se-123', carrier_code: 'stamps_com' }.to_json)

    response = client.get_carrier_by_id('se-123')
    assert_equal 'se-123', response['carrier_id']
    assert_requested(stub, times: 1)
  end

  it 'disconnects a carrier' do
    stub = stub_request(:delete, 'https://api.shipengine.com/v1/carriers/se-123')
           .to_return(status: 204, body: {}.to_json)

    client.disconnect_carrier('se-123')
    assert_requested(stub, times: 1)
  end

  it 'adds funds to a carrier' do
    params = { currency: 'usd', amount: 25.00 }

    stub = stub_request(:put, 'https://api.shipengine.com/v1/carriers/se-123/add_funds')
           .with(body: params.to_json)
           .to_return(status: 200, body: { currency: 'usd', amount: 125.00 }.to_json)

    response = client.add_funds_to_carrier('se-123', params)
    assert_equal 125.00, response['amount']
    assert_requested(stub, times: 1)
  end

  it 'lists carrier services' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/carriers/se-123/services')
           .to_return(status: 200, body: {
             services: [{ service_code: 'usps_priority', name: 'USPS Priority' }]
           }.to_json)

    response = client.list_carrier_services('se-123')
    assert_equal 1, response['services'].length
    assert_requested(stub, times: 1)
  end

  it 'lists carrier packages' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/carriers/se-123/packages')
           .to_return(status: 200, body: {
             packages: [{ package_code: 'flat_rate_box', name: 'Flat Rate Box' }]
           }.to_json)

    response = client.list_carrier_packages('se-123')
    assert_equal 1, response['packages'].length
    assert_requested(stub, times: 1)
  end

  it 'lists carrier options' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/carriers/se-123/options')
           .to_return(status: 200, body: {
             options: [{ name: 'contains_alcohol', default_value: 'false' }]
           }.to_json)

    response = client.list_carrier_options('se-123')
    assert_equal 1, response['options'].length
    assert_requested(stub, times: 1)
  end
end
