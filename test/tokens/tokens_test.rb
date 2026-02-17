# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Tokens' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  it 'gets an ephemeral token' do
    stub = stub_request(:post, 'https://api.shipengine.com/v1/tokens/ephemeral')
           .to_return(status: 200, body: { token: 'ephemeral_token_xyz' }.to_json)

    response = client.tokens.get_ephemeral_token
    assert_equal 'ephemeral_token_xyz', response['token']
    assert_requested(stub, times: 1)
  end
end
