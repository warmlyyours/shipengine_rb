# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Account' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'gets account settings' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/account/settings')
           .to_return(status: 200, body: { account_id: 'acc-123' }.to_json)

    response = client.account.get_settings
    assert_equal 'acc-123', response['account_id']
    assert_requested(stub, times: 1)
  end

  it 'updates account settings' do
    params = { default_label_layout: '4x6' }

    stub = stub_request(:put, 'https://api.shipengine.com/v1/account/settings')
           .with(body: params.to_json)
           .to_return(status: 200, body: {}.to_json)

    client.account.update_settings(params)
    assert_requested(stub, times: 1)
  end

  it 'lists account images' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/account/settings/images')
           .to_return(status: 200, body: { images: [{ image_id: 'img-1' }] }.to_json)

    response = client.account.list_images
    assert_equal 'img-1', response['images'][0]['image_id']
    assert_requested(stub, times: 1)
  end

  it 'gets an account image' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/account/settings/images/img-1')
           .to_return(status: 200, body: { image_id: 'img-1', label_image_url: 'https://...' }.to_json)

    response = client.account.get_image('img-1')
    assert_equal 'img-1', response['image_id']
    assert_requested(stub, times: 1)
  end

  it 'creates an account image' do
    params = { label_image_url: 'https://example.com/logo.png' }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/account/settings/images')
           .with(body: params.to_json)
           .to_return(status: 200, body: { image_id: 'img-2' }.to_json)

    response = client.account.create_image(params)
    assert_equal 'img-2', response['image_id']
    assert_requested(stub, times: 1)
  end

  it 'updates an account image' do
    params = { label_image_url: 'https://example.com/new-logo.png' }

    stub = stub_request(:put, 'https://api.shipengine.com/v1/account/settings/images/img-1')
           .with(body: params.to_json)
           .to_return(status: 204, body: {}.to_json)

    client.account.update_image('img-1', params)
    assert_requested(stub, times: 1)
  end

  it 'deletes an account image' do
    stub = stub_request(:delete, 'https://api.shipengine.com/v1/account/settings/images/img-1')
           .to_return(status: 204, body: {}.to_json)

    client.account.delete_image('img-1')
    assert_requested(stub, times: 1)
  end
end
