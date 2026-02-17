# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Warehouses' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'lists warehouses' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/warehouses')
           .to_return(status: 200, body: {
             warehouses: [{ warehouse_id: 'wh-123', name: 'Main Warehouse' }]
           }.to_json)

    response = client.warehouses.list
    assert_equal 1, response['warehouses'].length
    assert_equal 'wh-123', response['warehouses'][0]['warehouse_id']
    assert_requested(stub, times: 1)
  end

  it 'creates a warehouse' do
    params = { name: 'New Warehouse', origin_address: { address_line1: '123 Main St' } }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/warehouses')
           .with(body: params.to_json)
           .to_return(status: 200, body: { warehouse_id: 'wh-456', name: 'New Warehouse' }.to_json)

    response = client.warehouses.create(params)
    assert_equal 'wh-456', response['warehouse_id']
    assert_requested(stub, times: 1)
  end

  it 'gets a warehouse by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/warehouses/wh-123')
           .to_return(status: 200, body: { warehouse_id: 'wh-123', name: 'Main Warehouse' }.to_json)

    response = client.warehouses.get_by_id('wh-123')
    assert_equal 'wh-123', response['warehouse_id']
    assert_requested(stub, times: 1)
  end

  it 'updates a warehouse' do
    params = { name: 'Updated Warehouse' }

    stub = stub_request(:put, 'https://api.shipengine.com/v1/warehouses/wh-123')
           .with(body: params.to_json)
           .to_return(status: 200, body: {}.to_json)

    client.warehouses.update('wh-123', params)
    assert_requested(stub, times: 1)
  end

  it 'deletes a warehouse' do
    stub = stub_request(:delete, 'https://api.shipengine.com/v1/warehouses/wh-123')
           .to_return(status: 204, body: {}.to_json)

    client.warehouses.delete('wh-123')
    assert_requested(stub, times: 1)
  end

  it 'updates warehouse settings' do
    params = { is_default: true }

    stub = stub_request(:put, 'https://api.shipengine.com/v1/warehouses/wh-123/settings')
           .with(body: params.to_json)
           .to_return(status: 204, body: {}.to_json)

    client.warehouses.update_settings('wh-123', params)
    assert_requested(stub, times: 1)
  end
end
