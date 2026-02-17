# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Package Types' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'lists package types' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/packages')
           .to_return(status: 200, body: {
             packages: [{ package_id: 'pkg-1', package_code: 'custom_box', name: 'Custom Box' }]
           }.to_json)

    response = client.package_types.list
    assert_equal 1, response[:packages].length
    assert_requested(stub, times: 1)
  end

  it 'creates a package type' do
    params = { package_code: 'my_box', name: 'My Box', dimensions: { unit: 'inch', length: 10, width: 8, height: 6 } }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/packages')
           .with(body: params.to_json)
           .to_return(status: 200, body: { package_id: 'pkg-2', package_code: 'my_box' }.to_json)

    response = client.package_types.create(params)
    assert_equal 'pkg-2', response[:package_id]
    assert_requested(stub, times: 1)
  end

  it 'gets a package type by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/packages/pkg-1')
           .to_return(status: 200, body: { package_id: 'pkg-1', name: 'Custom Box' }.to_json)

    response = client.package_types.get_by_id('pkg-1')
    assert_equal 'pkg-1', response[:package_id]
    assert_requested(stub, times: 1)
  end

  it 'updates a package type' do
    params = { name: 'Updated Box' }

    stub = stub_request(:put, 'https://api.shipengine.com/v1/packages/pkg-1')
           .with(body: params.to_json)
           .to_return(status: 200, body: {}.to_json)

    client.package_types.update('pkg-1', params)
    assert_requested(stub, times: 1)
  end

  it 'deletes a package type' do
    stub = stub_request(:delete, 'https://api.shipengine.com/v1/packages/pkg-1')
           .to_return(status: 204, body: {}.to_json)

    client.package_types.delete('pkg-1')
    assert_requested(stub, times: 1)
  end
end
