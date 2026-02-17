# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Webhooks' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'lists webhooks' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/environment/webhooks')
           .to_return(status: 200, body: [
             { webhook_id: 'wh-1', url: 'https://example.com/hook', event: 'track' }
           ].to_json)

    response = client.webhooks.list
    assert_equal 1, response.length
    assert_equal 'wh-1', response[0][:webhook_id]
    assert_requested(stub, times: 1)
  end

  it 'creates a webhook' do
    params = { url: 'https://example.com/hook', event: 'track' }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/environment/webhooks')
           .with(body: params.to_json)
           .to_return(status: 200, body: { webhook_id: 'wh-2', url: 'https://example.com/hook' }.to_json)

    response = client.webhooks.create(params)
    assert_equal 'wh-2', response[:webhook_id]
    assert_requested(stub, times: 1)
  end

  it 'gets a webhook by ID' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/environment/webhooks/wh-1')
           .to_return(status: 200, body: { webhook_id: 'wh-1', url: 'https://example.com/hook' }.to_json)

    response = client.webhooks.get_by_id('wh-1')
    assert_equal 'wh-1', response[:webhook_id]
    assert_requested(stub, times: 1)
  end

  it 'updates a webhook' do
    params = { url: 'https://example.com/new-hook' }

    stub = stub_request(:put, 'https://api.shipengine.com/v1/environment/webhooks/wh-1')
           .with(body: params.to_json)
           .to_return(status: 200, body: {}.to_json)

    client.webhooks.update('wh-1', params)
    assert_requested(stub, times: 1)
  end

  it 'deletes a webhook' do
    stub = stub_request(:delete, 'https://api.shipengine.com/v1/environment/webhooks/wh-1')
           .to_return(status: 204, body: {}.to_json)

    client.webhooks.delete('wh-1')
    assert_requested(stub, times: 1)
  end
end
