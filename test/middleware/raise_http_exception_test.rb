# frozen_string_literal: true

require 'test_helper'
require 'json'

describe 'Middleware::RaiseHttpException' do
  after do
    WebMock.reset!
  end

  client = ShipEngineRb::Client.new('TEST_ycvJAgX6tLB1Awm9WGJmD8mpZ8wXiQ20WhqFowCk32s')

  describe 'HTTP 400 errors' do
    it 'raises a typed error for validation errors' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels/bad-id')
        .to_return(status: 400, body: {
          request_id: 'req_abc',
          errors: [{
            error_source: 'shipengine',
            error_type: 'validation',
            error_code: 'invalid_field_value',
            message: 'Invalid label ID'
          }]
        }.to_json)

      err = assert_raises(ShipEngineRb::Exceptions::ValidationError) do
        client.labels.get_by_id('bad-id')
      end
      assert_equal 'Invalid label ID', err.message
      assert_equal 'req_abc', err.request_id
    end
  end

  describe 'HTTP 401 errors' do
    it 'raises a security error for unauthorized requests' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels')
        .to_return(status: 401, body: {
          request_id: 'req_401',
          errors: [{
            error_source: 'shipengine',
            error_type: 'security',
            error_code: 'unauthorized',
            message: 'Invalid API key'
          }]
        }.to_json)

      err = assert_raises(ShipEngineRb::Exceptions::SecurityError) do
        client.labels.list
      end
      assert_equal 'Invalid API key', err.message
    end
  end

  describe 'HTTP 404 errors' do
    it 'raises an error for not found resources' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels/se-nonexistent')
        .to_return(status: 404, body: {
          request_id: 'req_404',
          errors: [{
            error_source: 'shipengine',
            error_type: 'validation',
            error_code: 'not_found',
            message: 'Label not found'
          }]
        }.to_json)

      err = assert_raises(ShipEngineRb::Exceptions::ValidationError) do
        client.labels.get_by_id('se-nonexistent')
      end
      assert_equal 'Label not found', err.message
    end
  end

  describe 'HTTP 500 errors' do
    it 'raises a system error for server errors' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels')
        .to_return(status: 500, body: {
          request_id: 'req_500',
          errors: [{
            error_source: 'shipengine',
            error_type: 'system',
            error_code: 'unspecified',
            message: 'Internal server error'
          }]
        }.to_json)

      err = assert_raises(ShipEngineRb::Exceptions::SystemError) do
        client.labels.list
      end
      assert_equal 'Internal server error', err.message
    end
  end

  describe 'edge cases' do
    it 'handles empty error body gracefully' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels')
        .to_return(status: 500, body: '')

      err = assert_raises(ShipEngineRb::Exceptions::ShipEngineError) do
        client.labels.list
      end
      assert_match(/HTTP 500/, err.message)
    end

    it 'handles nil error body gracefully' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels')
        .to_return(status: 500, body: nil)

      err = assert_raises(ShipEngineRb::Exceptions::ShipEngineError) do
        client.labels.list
      end
      assert_match(/HTTP 500/, err.message)
    end

    it 'raises Faraday::ParsingError for malformed JSON body' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels')
        .to_return(status: 500, body: 'not json at all')

      assert_raises(Faraday::ParsingError) do
        client.labels.list
      end
    end

    it 'handles error body with no errors array' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels')
        .to_return(status: 500, body: { request_id: 'req_x' }.to_json)

      err = assert_raises(ShipEngineRb::Exceptions::ShipEngineError) do
        client.labels.list
      end
      assert_match(/HTTP 500/, err.message)
    end

    it 'handles account_status error type' do
      stub_request(:get, 'https://api.shipengine.com/v1/labels')
        .to_return(status: 403, body: {
          request_id: 'req_403',
          errors: [{
            error_source: 'shipengine',
            error_type: 'account_status',
            error_code: 'subscription_inactive',
            message: 'Subscription is inactive'
          }]
        }.to_json)

      err = assert_raises(ShipEngineRb::Exceptions::AccountStatusError) do
        client.labels.list
      end
      assert_equal 'Subscription is inactive', err.message
    end

    it 'handles business_rules error type' do
      stub_request(:post, 'https://api.shipengine.com/v1/labels')
        .to_return(status: 400, body: {
          request_id: 'req_br',
          errors: [{
            error_source: 'shipengine',
            error_type: 'business_rules',
            error_code: 'batch_cannot_be_modified',
            message: 'Batch is locked'
          }]
        }.to_json)

      err = assert_raises(ShipEngineRb::Exceptions::BusinessRulesError) do
        client.labels.create_from_shipment_details({ shipment: {} })
      end
      assert_equal 'Batch is locked', err.message
    end
  end
end
