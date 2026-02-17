# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Labels Extended Operations' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'lists labels' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/labels')
           .to_return(status: 200, body: {
             labels: [{ label_id: 'se-label-1', status: 'completed' }],
             total: 1, page: 1, pages: 1
           }.to_json)

    response = client.labels.list
    assert_equal 1, response['total']
    assert_equal 'se-label-1', response['labels'][0]['label_id']
    assert_requested(stub, times: 1)
  end

  it 'gets a label by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/labels/se-label-1')
           .to_return(status: 200, body: { label_id: 'se-label-1', status: 'completed' }.to_json)

    response = client.labels.get_by_id('se-label-1')
    assert_equal 'se-label-1', response['label_id']
    assert_requested(stub, times: 1)
  end

  it 'gets a label by external shipment ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/labels/external_shipment_id/ext-ship-1')
           .to_return(status: 200, body: { label_id: 'se-label-1' }.to_json)

    response = client.labels.get_by_external_shipment_id('ext-ship-1')
    assert_equal 'se-label-1', response['label_id']
    assert_requested(stub, times: 1)
  end

  it 'creates a return label' do
    params = { label_format: 'pdf', label_layout: '4x6' }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/labels/se-label-1/return')
           .with(body: params.to_json)
           .to_return(status: 200, body: { label_id: 'se-return-1', is_return_label: true }.to_json)

    response = client.labels.create_return_label('se-label-1', params)
    assert_equal true, response['is_return_label']
    assert_equal 'se-return-1', response['label_id']
    assert_requested(stub, times: 1)
  end

  it 'creates a label from shipment ID' do
    params = { label_format: 'pdf' }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/labels/shipment/se-ship-1')
           .with(body: params.to_json)
           .to_return(status: 200, body: { label_id: 'se-label-new', shipment_id: 'se-ship-1' }.to_json)

    response = client.labels.create_from_shipment_id('se-ship-1', params)
    assert_equal 'se-label-new', response['label_id']
    assert_equal 'se-ship-1', response['shipment_id']
    assert_requested(stub, times: 1)
  end
end
