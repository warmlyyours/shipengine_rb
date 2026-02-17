# frozen_string_literal: true

require 'test_helper'

describe 'Configuration' do
  describe 'common functionality' do
    it 'should accept an api_key only constructor' do
      client = ShipEngineRb::Client.new('foo')

      assert_equal 'foo', client.configuration.api_key
    end

    it 'default values should be passed' do
      client = ShipEngineRb::Client.new('foo')

      assert_equal 60_000, client.configuration.timeout
      assert_equal 50, client.configuration.page_size
    end

    it 'configuration is frozen (immutable)' do
      client = ShipEngineRb::Client.new('foo')
      assert client.configuration.frozen?
    end

    it 'per-request config overrides work without mutating global config' do
      stub = stub_request(:post, 'https://api.shipengine.com/v1/addresses/validate')
             .with(body: /.*/, headers: { 'API-Key' => 'baz' })
             .to_return(status: 200, body: Factory.valid_address_res_json)

      client = ShipEngineRb::Client.new('foo', timeout: 111_000)
      assert_equal 'foo', client.configuration.api_key
      assert_equal 111_000, client.configuration.timeout

      client.addresses.validate(Factory.valid_address_params, config: { api_key: 'baz', timeout: 222_000 })
      assert_requested(stub)

      # global configuration is unchanged
      assert_equal 'foo', client.configuration.api_key
      assert_equal 111_000, client.configuration.timeout
      assert_equal 50, client.configuration.page_size
    end
  end

  describe 'page_size' do
    it 'Should throw an error if page size is invalid at instantiation or at method call' do
      page_size_err = { message: 'Page size must be greater than zero.', code: ShipEngineRb::Exceptions::ErrorCode.get(:INVALID_FIELD_VALUE) }

      stub = stub_request(:post, 'https://api.shipengine.com/v1/addresses/validate')
             .with(body: /.*/)
             .to_return(status: 200, body: Factory.valid_address_res_json)

      # configuration during insantiation
      assert_raises_shipengine_validation(page_size_err) do
        ShipEngineRb::Client.new('abc1234', page_size: 0)
      end

      # config during method call
      assert_raises_shipengine_validation(page_size_err) do
        client = ShipEngineRb::Client.new('abc1234')
        client.addresses.validate(Factory.valid_address_params, config: { page_size: 0 })
      end

      assert_not_requested(stub)
      ShipEngineRb::Client.new('abc1234', page_size: 5)
    end
  end

  describe 'api_key' do
    it 'should throw an error if api_key is invalid at instantiation or at method call' do
      api_key_err = {
        source: 'shipengine',
        type: 'validation',
        code: ShipEngineRb::Exceptions::ErrorCode.get(:FIELD_VALUE_REQUIRED),
        message: 'A ShipEngine API key must be specified.'
      }

      stub = stub_request(:post, 'https://api.shipengine.com/v1/addresses/validate')
             .with(body: /.*/)
             .to_return(status: 200, body: Factory.valid_address_res_json)

      # configuration during insantiation
      assert_raises_shipengine_validation(api_key_err) do
        ShipEngineRb::Client.new(nil)
      end

      # config during method call
      assert_raises_shipengine_validation(api_key_err) do
        client = ShipEngineRb::Client.new('foo')
        client.addresses.validate(Factory.valid_address_params, config: { api_key: nil })
      end

      assert_not_requested(stub)

      ShipEngineRb::Client.new('abc1234') # valid
      ShipEngineRb::Client.new('abc1234') # valid
    end
  end
end
