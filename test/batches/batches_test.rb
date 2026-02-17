# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Batches' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'lists batches' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/batches')
           .to_return(status: 200, body: {
             batches: [{ batch_id: 'se-batch-1', status: 'open' }],
             total: 1, page: 1, pages: 1
           }.to_json)

    response = client.batches.list
    assert_equal 1, response['total']
    assert_equal 'se-batch-1', response['batches'][0]['batch_id']
    assert_requested(stub, times: 1)
  end

  it 'creates a batch' do
    params = { shipment_ids: ['se-12345'] }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/batches')
           .with(body: params.to_json)
           .to_return(status: 200, body: { batch_id: 'se-batch-2', status: 'open' }.to_json)

    response = client.batches.create(params)
    assert_equal 'se-batch-2', response['batch_id']
    assert_requested(stub, times: 1)
  end

  it 'gets a batch by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/batches/se-batch-1')
           .to_return(status: 200, body: { batch_id: 'se-batch-1', status: 'open' }.to_json)

    response = client.batches.get_by_id('se-batch-1')
    assert_equal 'se-batch-1', response['batch_id']
    assert_requested(stub, times: 1)
  end

  it 'deletes a batch' do
    stub = stub_request(:delete, 'https://api.shipengine.com/v1/batches/se-batch-1')
           .to_return(status: 204, body: {}.to_json)

    client.batches.delete('se-batch-1')
    assert_requested(stub, times: 1)
  end

  it 'processes a batch' do
    stub = stub_request(:post, 'https://api.shipengine.com/v1/batches/se-batch-1/process/labels')
           .to_return(status: 204, body: {}.to_json)

    client.batches.process('se-batch-1')
    assert_requested(stub, times: 1)
  end

  it 'gets a batch by external ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/batches/external_batch_id/ext-batch-1')
           .to_return(status: 200, body: { batch_id: 'se-batch-1', external_batch_id: 'ext-batch-1' }.to_json)

    response = client.batches.get_by_external_id('ext-batch-1')
    assert_equal 'se-batch-1', response['batch_id']
    assert_equal 'ext-batch-1', response['external_batch_id']
    assert_requested(stub, times: 1)
  end

  it 'adds shipments to a batch' do
    params = { shipment_ids: ['se-ship-1', 'se-ship-2'] }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/batches/se-batch-1/add')
           .with(body: params.to_json)
           .to_return(status: 204, body: {}.to_json)

    client.batches.add_shipments('se-batch-1', params)
    assert_requested(stub, times: 1)
  end

  it 'removes shipments from a batch' do
    params = { shipment_ids: ['se-ship-1'] }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/batches/se-batch-1/remove')
           .with(body: params.to_json)
           .to_return(status: 204, body: {}.to_json)

    client.batches.remove_shipments('se-batch-1', params)
    assert_requested(stub, times: 1)
  end

  it 'gets batch errors' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/batches/se-batch-1/errors')
           .to_return(status: 200, body: {
             errors: [{ error: 'Invalid address' }]
           }.to_json)

    response = client.batches.get_errors('se-batch-1')
    assert_equal 1, response['errors'].length
    assert_requested(stub, times: 1)
  end
end
