# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'LTL Freight' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'lists LTL carriers' do
    stub = stub_request(:get, 'https://api.shipengine.com/v-beta/ltl/carriers')
           .to_return(status: 200, body: {
             carriers: [{ carrier_id: 'ltl-1', name: 'R+L Carriers' }]
           }.to_json)
    response = client.ltl.list_carriers
    assert_equal 1, response[:carriers].length
    assert_requested(stub, times: 1)
  end

  it 'gets an LTL quote' do
    params = { origin: {}, destination: {}, packages: [] }
    stub = stub_request(:post, 'https://api.shipengine.com/v-beta/ltl/quotes/ltl-1')
           .with(body: params.to_json)
           .to_return(status: 200, body: { quote_id: 'q-1', total: { amount: 250.00 } }.to_json)
    response = client.ltl.get_quote('ltl-1', params)
    assert_equal 'q-1', response[:quote_id]
    assert_requested(stub, times: 1)
  end

  it 'lists LTL quotes' do
    stub = stub_request(:get, 'https://api.shipengine.com/v-beta/ltl/quotes')
           .to_return(status: 200, body: { quotes: [] }.to_json)
    response = client.ltl.list_quotes
    assert_equal [], response[:quotes]
    assert_requested(stub, times: 1)
  end

  it 'gets an LTL quote by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v-beta/ltl/quotes/q-1')
           .to_return(status: 200, body: { quote_id: 'q-1' }.to_json)
    response = client.ltl.get_quote_by_id('q-1')
    assert_equal 'q-1', response[:quote_id]
    assert_requested(stub, times: 1)
  end

  it 'schedules an LTL pickup' do
    params = { quote_id: 'q-1', pickup_date: '2026-02-20' }
    stub = stub_request(:post, 'https://api.shipengine.com/v-beta/ltl/pickups')
           .with(body: params.to_json)
           .to_return(status: 200, body: { pickup_id: 'p-1' }.to_json)
    response = client.ltl.schedule_pickup(params)
    assert_equal 'p-1', response[:pickup_id]
    assert_requested(stub, times: 1)
  end

  it 'gets an LTL pickup' do
    stub = stub_request(:get, 'https://api.shipengine.com/v-beta/ltl/pickups/p-1')
           .to_return(status: 200, body: { pickup_id: 'p-1' }.to_json)
    response = client.ltl.get_pickup('p-1')
    assert_equal 'p-1', response[:pickup_id]
    assert_requested(stub, times: 1)
  end

  it 'updates an LTL pickup' do
    params = { pickup_date: '2026-02-21' }
    stub = stub_request(:put, 'https://api.shipengine.com/v-beta/ltl/pickups/p-1')
           .with(body: params.to_json)
           .to_return(status: 200, body: { pickup_id: 'p-1' }.to_json)
    response = client.ltl.update_pickup('p-1', params)
    assert_equal 'p-1', response[:pickup_id]
    assert_requested(stub, times: 1)
  end

  it 'cancels an LTL pickup' do
    stub = stub_request(:delete, 'https://api.shipengine.com/v-beta/ltl/pickups/p-1')
           .to_return(status: 204, body: {}.to_json)
    client.ltl.cancel_pickup('p-1')
    assert_requested(stub, times: 1)
  end

  it 'tracks an LTL shipment' do
    stub = stub_request(:get, 'https://api.shipengine.com/v-beta/ltl/tracking?tracking_number=LTL123')
           .to_return(status: 200, body: { tracking_number: 'LTL123', status: 'in_transit' }.to_json)
    response = client.ltl.track({ tracking_number: 'LTL123' })
    assert_equal 'LTL123', response[:tracking_number]
    assert_requested(stub, times: 1)
  end
end
