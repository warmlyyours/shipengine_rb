# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Shipments' do
  after do
    WebMock.reset!
  end

  client = ShipEngine::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'lists shipments' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/shipments')
           .to_return(status: 200, body: {
             shipments: [{ shipment_id: 'se-12345', shipment_status: 'pending' }],
             total: 1, page: 1, pages: 1
           }.to_json)

    response = client.list_shipments
    assert_equal 1, response['total']
    assert_equal 'se-12345', response['shipments'][0]['shipment_id']
    assert_requested(stub, times: 1)
  end

  it 'creates a shipment' do
    params = { shipments: [{ service_code: 'usps_priority_mail', ship_to: {}, ship_from: {}, packages: [] }] }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/shipments')
           .with(body: params.to_json)
           .to_return(status: 200, body: {
             has_errors: false,
             shipments: [{ shipment_id: 'se-99999', shipment_status: 'pending' }]
           }.to_json)

    response = client.create_shipments(params)
    assert_equal false, response['has_errors']
    assert_requested(stub, times: 1)
  end

  it 'gets a shipment by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/shipments/se-12345')
           .to_return(status: 200, body: { shipment_id: 'se-12345', shipment_status: 'pending' }.to_json)

    response = client.get_shipment_by_id('se-12345')
    assert_equal 'se-12345', response['shipment_id']
    assert_requested(stub, times: 1)
  end

  it 'updates a shipment' do
    stub = stub_request(:put, 'https://api.shipengine.com/v1/shipments/se-12345')
           .to_return(status: 200, body: { shipment_id: 'se-12345', shipment_status: 'pending' }.to_json)

    response = client.update_shipment('se-12345', { service_code: 'usps_first_class_mail' })
    assert_equal 'se-12345', response['shipment_id']
    assert_requested(stub, times: 1)
  end

  it 'cancels a shipment' do
    stub = stub_request(:put, 'https://api.shipengine.com/v1/shipments/se-12345/cancel')
           .to_return(status: 200, body: {}.to_json)

    client.cancel_shipment('se-12345')
    assert_requested(stub, times: 1)
  end

  it 'tags a shipment' do
    stub = stub_request(:post, 'https://api.shipengine.com/v1/shipments/se-12345/tags/priority')
           .to_return(status: 200, body: { shipment_id: 'se-12345', tag_name: 'priority' }.to_json)

    response = client.tag_shipment('se-12345', 'priority')
    assert_equal 'priority', response['tag_name']
    assert_requested(stub, times: 1)
  end

  it 'untags a shipment' do
    stub = stub_request(:delete, 'https://api.shipengine.com/v1/shipments/se-12345/tags/priority')
           .to_return(status: 200, body: {}.to_json)

    client.untag_shipment('se-12345', 'priority')
    assert_requested(stub, times: 1)
  end

  it 'gets a shipment by external ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/shipments/external_shipment_id/ext-ship-1')
           .to_return(status: 200, body: { shipment_id: 'se-12345', external_shipment_id: 'ext-ship-1' }.to_json)

    response = client.get_shipment_by_external_id('ext-ship-1')
    assert_equal 'se-12345', response['shipment_id']
    assert_equal 'ext-ship-1', response['external_shipment_id']
    assert_requested(stub, times: 1)
  end

  it 'parses shipping info from text' do
    params = { text: 'Ship to John Smith at 123 Main St, Austin TX 78701' }

    stub = stub_request(:put, 'https://api.shipengine.com/v1/shipments/recognize')
           .with(body: params.to_json)
           .to_return(status: 200, body: {
             score: 0.9,
             shipment: { ship_to: { name: 'John Smith' } }
           }.to_json)

    response = client.parse_shipment(params)
    assert_equal 0.9, response['score']
    assert_equal 'John Smith', response.dig('shipment', 'ship_to', 'name')
    assert_requested(stub, times: 1)
  end

  it 'gets rates for a shipment' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/shipments/se-12345/rates')
           .to_return(status: 200, body: {
             rates: [{ rate_id: 'rate-1', shipping_amount: { amount: 5.99 } }]
           }.to_json)

    response = client.get_shipment_rates('se-12345')
    assert_equal 'rate-1', response['rates'][0]['rate_id']
    assert_requested(stub, times: 1)
  end

  it 'lists tags for a shipment' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/shipments/se-12345/tags')
           .to_return(status: 200, body: { tags: [{ name: 'priority' }] }.to_json)

    response = client.list_shipment_tags('se-12345')
    assert_equal 'priority', response['tags'][0]['name']
    assert_requested(stub, times: 1)
  end

  it 'bulk updates shipment tags' do
    params = { shipment_ids: ['se-12345'], tags: [{ name: 'priority' }] }

    stub = stub_request(:put, 'https://api.shipengine.com/v1/shipments/tags')
           .with(body: params.to_json)
           .to_return(status: 204, body: {}.to_json)

    client.update_shipment_tags(params)
    assert_requested(stub, times: 1)
  end
end
