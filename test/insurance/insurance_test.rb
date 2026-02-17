# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Insurance' do
  after do
    WebMock.reset!
  end

  client = ShipEngine::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'gets insurance balance' do
    stub = stub_request(:get, 'https://api.shipengine.com/v1/insurance/shipsurance/balance')
           .to_return(status: 200, body: { currency: 'usd', amount: 100.50 }.to_json)

    response = client.get_insurance_balance
    assert_equal 'usd', response['currency']
    assert_equal 100.50, response['amount']
    assert_requested(stub, times: 1)
  end

  it 'adds funds to insurance' do
    params = { currency: 'usd', amount: 50.00 }

    stub = stub_request(:patch, 'https://api.shipengine.com/v1/insurance/shipsurance/add_funds')
           .with(body: params.to_json)
           .to_return(status: 200, body: { currency: 'usd', amount: 150.50 }.to_json)

    response = client.add_insurance_funds(params)
    assert_equal 150.50, response['amount']
    assert_requested(stub, times: 1)
  end

  it 'connects shipsurance' do
    stub = stub_request(:post, 'https://api.shipengine.com/v1/connections/insurance/shipsurance')
           .to_return(status: 204, body: {}.to_json)

    client.connect_insurance
    assert_requested(stub, times: 1)
  end

  it 'disconnects shipsurance' do
    stub = stub_request(:delete, 'https://api.shipengine.com/v1/connections/insurance/shipsurance')
           .to_return(status: 204, body: {}.to_json)

    client.disconnect_insurance
    assert_requested(stub, times: 1)
  end
end
