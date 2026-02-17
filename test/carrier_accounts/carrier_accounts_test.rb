# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Carrier Accounts' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'connects a carrier account' do
    params = { nickname: 'My FedEx', account_number: '1234567890' }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/connections/carriers/fedex')
           .with(body: params.to_json)
           .to_return(status: 200, body: { carrier_id: 'se-fedex-1' }.to_json)

    response = client.carrier_accounts.connect('fedex', params)
    assert_equal 'se-fedex-1', response['carrier_id']
    assert_requested(stub, times: 1)
  end

  it 'disconnects a carrier account' do
    stub = stub_request(:delete, 'https://api.shipengine.com/v1/connections/carriers/fedex/se-fedex-1')
           .to_return(status: 204, body: {}.to_json)

    client.carrier_accounts.disconnect('fedex', 'se-fedex-1')
    assert_requested(stub, times: 1)
  end

  it 'gets carrier account settings' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/connections/carriers/fedex/se-fedex-1/settings')
           .to_return(status: 200, body: { nickname: 'My FedEx', is_primary_account: true }.to_json)

    response = client.carrier_accounts.get_settings('fedex', 'se-fedex-1')
    assert_equal 'My FedEx', response['nickname']
    assert_equal true, response['is_primary_account']
    assert_requested(stub, times: 1)
  end

  it 'updates carrier account settings' do
    params = { nickname: 'Updated FedEx' }

    stub = stub_request(:put, 'https://api.shipengine.com/v1/connections/carriers/fedex/se-fedex-1/settings')
           .with(body: params.to_json)
           .to_return(status: 204, body: {}.to_json)

    client.carrier_accounts.update_settings('fedex', 'se-fedex-1', params)
    assert_requested(stub, times: 1)
  end
end
