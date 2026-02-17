# frozen_string_literal: true

require 'test_helper'

describe 'timeout' do
  it 'Should throw an error if timeout is invalid at instantiation or at method call' do
    timeout_err = { message: 'Timeout must be greater than zero.', code: ShipEngineRb::Exceptions::ErrorCode.get(:INVALID_FIELD_VALUE) }

    stub = stub_request(:post, 'https://api.shipengine.com/v1/addresses/validate')
           .with(body: /.*/)
           .to_return(status: 200, body: Factory.valid_address_res_json)

    # configuration during insantiation
    assert_raises_shipengine_validation(timeout_err) do
      ShipEngineRb::Client.new('abc1234', timeout: 0)
    end

    # config during method call
    assert_raises_shipengine_validation(timeout_err) do
      client = ShipEngineRb::Client.new('abc1234')
      client.addresses.validate(Factory.valid_address_params, config: { timeout: -1 })
    end

    assert_not_requested(stub)
    ShipEngineRb::Client.new('abc1234', timeout: 5000) # valid timeout
  end
end
