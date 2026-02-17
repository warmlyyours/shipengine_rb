# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Tags' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'lists tags' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/tags')
           .to_return(status: 200, body: {
             tags: [{ name: 'priority' }, { name: 'fragile' }]
           }.to_json)

    response = client.tags.list
    assert_equal 2, response[:tags].length
    assert_requested(stub, times: 1)
  end

  it 'creates a tag' do
    stub = stub_request(:post, 'https://api.shipengine.com/v1/tags/priority')
           .to_return(status: 200, body: { name: 'priority' }.to_json)

    response = client.tags.create('priority')
    assert_equal 'priority', response[:name]
    assert_requested(stub, times: 1)
  end

  it 'deletes a tag' do
    stub = stub_request(:delete, 'https://api.shipengine.com/v1/tags/priority')
           .to_return(status: 204, body: {}.to_json)

    client.tags.delete('priority')
    assert_requested(stub, times: 1)
  end

  it 'renames a tag' do
    stub = stub_request(:put, 'https://api.shipengine.com/v1/tags/priority/urgent')
           .to_return(status: 200, body: {}.to_json)

    client.tags.rename('priority', 'urgent')
    assert_requested(stub, times: 1)
  end
end
