# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Rates Extended Operations' do
  after do
    WebMock.reset!
  end

  client = ShipEngine::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

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

    response = client.estimate_rates(params)
    assert_equal 1, response.length
    assert_equal 'usps_priority', response[0]['service_code']
    assert_requested(stub, times: 1)
  end

  it 'gets a rate by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/rates/se-rate-1')
           .to_return(status: 200, body: { rate_id: 'se-rate-1', rate_type: 'shipment' }.to_json)

    response = client.get_rate_by_id('se-rate-1')
    assert_equal 'se-rate-1', response['rate_id']
    assert_requested(stub, times: 1)
  end

  it 'gets bulk rates' do
    params = { shipment_ids: ['se-ship-1', 'se-ship-2'], rate_options: {} }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/rates/bulk')
           .with(body: params.to_json)
           .to_return(status: 200, body: [].to_json)

    response = client.get_bulk_rates(params)
    assert_equal [], response
    assert_requested(stub, times: 1)
  end
end
