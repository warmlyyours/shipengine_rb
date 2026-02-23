# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Rates Extended Operations' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'estimates rates' do
    params = {
      carrier_ids: ['se-123'],
      from_postal_code: '78756',
      from_country_code: 'US',
      to_postal_code: '90210',
      to_country_code: 'US',
      weight: { value: 5, unit: 'ounce' }
    }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/rates/estimate')
           .with(body: params.to_json)
           .to_return(status: 200, body: [
             { rate_type: 'shipment', carrier_id: 'se-123', service_code: 'usps_priority',
               shipping_amount: { currency: 'usd', amount: 7.50 } }
           ].to_json)

    response = client.rates.estimate(params)
    assert_equal 1, response.length
    assert_equal 'usps_priority', response[0][:service_code]
    assert_requested(stub, times: 1)
  end

  it 'gets a rate by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/rates/se-rate-1')
           .to_return(status: 200, body: { rate_id: 'se-rate-1', rate_type: 'shipment' }.to_json)

    response = client.rates.get_by_id('se-rate-1')
    assert_equal 'se-rate-1', response[:rate_id]
    assert_requested(stub, times: 1)
  end

  it 'uses a dedicated connection for rates when rates_timeout is set' do
    client_with_rates_timeout = ShipEngineRb::Client.new(
      'TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s',
      timeout: 60_000,
      rates_timeout: 10_000
    )

    assert_equal 10_000, client_with_rates_timeout.rates.instance_variable_get(:@internal_client).configuration.timeout
    assert_equal 60_000, client_with_rates_timeout.labels.instance_variable_get(:@internal_client).configuration.timeout
  end

  it 'shares the same connection for rates when rates_timeout is not set' do
    client_no_rates_timeout = ShipEngineRb::Client.new(
      'TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s',
      timeout: 60_000
    )

    assert_equal 60_000, client_no_rates_timeout.rates.instance_variable_get(:@internal_client).configuration.timeout
    assert_same(
      client_no_rates_timeout.rates.instance_variable_get(:@internal_client),
      client_no_rates_timeout.labels.instance_variable_get(:@internal_client)
    )
  end

  it 'gets bulk rates' do
    params = { shipment_ids: ['se-ship-1', 'se-ship-2'], rate_options: {} }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/rates/bulk')
           .with(body: params.to_json)
           .to_return(status: 200, body: [].to_json)

    response = client.rates.bulk(params)
    assert_equal [], response
    assert_requested(stub, times: 1)
  end
end
