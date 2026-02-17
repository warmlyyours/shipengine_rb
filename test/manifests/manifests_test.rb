# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Manifests' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'lists manifests' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/manifests')
           .to_return(status: 200, body: {
             manifests: [{ manifest_id: 'man-1', carrier_id: 'se-carrier-1' }],
             total: 1, page: 1, pages: 1
           }.to_json)

    response = client.manifests.list
    assert_equal 1, response['total']
    assert_requested(stub, times: 1)
  end

  it 'creates a manifest' do
    params = { carrier_id: 'se-carrier-1', warehouse_id: 'wh-1', ship_date: '2026-02-17' }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/manifests')
           .with(body: params.to_json)
           .to_return(status: 200, body: { manifest_id: 'man-2' }.to_json)

    response = client.manifests.create(params)
    assert_equal 'man-2', response['manifest_id']
    assert_requested(stub, times: 1)
  end

  it 'gets a manifest by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/manifests/man-1')
           .to_return(status: 200, body: { manifest_id: 'man-1' }.to_json)

    response = client.manifests.get_by_id('man-1')
    assert_equal 'man-1', response['manifest_id']
    assert_requested(stub, times: 1)
  end

  it 'gets a manifest request by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/manifests/requests/req-1')
           .to_return(status: 200, body: { manifest_request_id: 'req-1', status: 'completed' }.to_json)

    response = client.manifests.get_request_by_id('req-1')
    assert_equal 'req-1', response['manifest_request_id']
    assert_equal 'completed', response['status']
    assert_requested(stub, times: 1)
  end
end
