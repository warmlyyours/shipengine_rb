# frozen_string_literal: true

require 'test_helper'

describe 'Exceptions' do
  E = ShipEngineRb::Exceptions
  EC = ShipEngineRb::Exceptions::ErrorCode
  ET = ShipEngineRb::Exceptions::ErrorType

  describe 'ShipEngineError' do
    it 'stores all attributes' do
      err = E::ShipEngineError.new(
        message: 'test error',
        source: 'carrier',
        type: 'system',
        code: 'unspecified',
        request_id: 'req_abc'
      )

      assert_equal 'test error', err.message
      assert_equal 'carrier', err.source
      assert_equal 'system', err.type
      assert_equal 'unspecified', err.code
      assert_equal 'req_abc', err.request_id
      assert_nil err.url
    end

    it 'defaults source to "shipengine" when nil' do
      err = E::ShipEngineError.new(
        message: 'test', source: nil, type: 'system',
        code: 'unspecified', request_id: nil
      )
      assert_equal 'shipengine', err.source
    end

    it 'resolves string error codes via ErrorCode.get_by_str' do
      err = E::ShipEngineError.new(
        message: 'test', source: 'shipengine', type: 'validation',
        code: 'invalid_field_value', request_id: nil
      )
      assert_equal EC.get(:INVALID_FIELD_VALUE), err.code
    end
  end

  describe 'ValidationError' do
    it 'sets type to validation' do
      err = E::ValidationError.new(message: 'bad value', code: EC.get(:INVALID_FIELD_VALUE))
      assert_equal ET.get(:VALIDATION), err.type
      assert_equal 'bad value', err.message
    end
  end

  describe 'BusinessRulesError' do
    it 'sets type to business_rules' do
      err = E::BusinessRulesError.new(message: 'rule broken', code: EC.get(:BATCH_CANNOT_BE_MODIFIED))
      assert_equal ET.get(:BUSINESS_RULES), err.type
    end
  end

  describe 'AccountStatusError' do
    it 'sets type to account_status' do
      err = E::AccountStatusError.new(message: 'inactive', code: EC.get(:SUBSCRIPTION_INACTIVE))
      assert_equal ET.get(:ACCOUNT_STATUS), err.type
    end
  end

  describe 'SecurityError' do
    it 'sets type to security' do
      err = E::SecurityError.new(message: 'unauthorized', code: EC.get(:UNAUTHORIZED))
      assert_equal ET.get(:SECURITY), err.type
    end
  end

  describe 'SystemError' do
    it 'sets type to system' do
      err = E::SystemError.new(message: 'internal error', code: EC.get(:UNSPECIFIED))
      assert_equal ET.get(:SYSTEM), err.type
    end

    it 'supports url parameter' do
      url = URI('https://example.com')
      err = E::SystemError.new(message: 'error', code: EC.get(:UNSPECIFIED), url:)
      assert_equal url, err.url
    end
  end

  describe 'TimeoutError' do
    it 'sets code to timeout and includes docs URL' do
      err = E::TimeoutError.new(message: 'request timed out')
      assert_equal EC.get(:TIMEOUT), err.code
      assert_equal URI('https://www.shipengine.com/docs/rate-limits'), err.url
      assert_equal 'shipengine', err.source
    end
  end

  describe 'RateLimitError' do
    it 'has default message' do
      err = E::RateLimitError.new
      assert_equal 'You have exceeded the rate limit.', err.message
      assert_equal EC.get(:RATE_LIMIT_EXCEEDED), err.code
    end

    it 'stores retries' do
      err = E::RateLimitError.new(retries: 3)
      assert_equal 3, err.retries
    end
  end

  describe '.create_error_instance' do
    it 'creates BusinessRulesError for business_rules type' do
      err = E.create_error_instance(
        type: ET.get(:BUSINESS_RULES),
        message: 'rule error',
        code: EC.get(:BATCH_CANNOT_BE_MODIFIED),
        request_id: 'req_1'
      )
      assert_instance_of E::BusinessRulesError, err
    end

    it 'creates ValidationError for validation type' do
      err = E.create_error_instance(
        type: ET.get(:VALIDATION),
        message: 'validation error',
        code: EC.get(:INVALID_FIELD_VALUE)
      )
      assert_instance_of E::ValidationError, err
    end

    it 'creates AccountStatusError for account_status type' do
      err = E.create_error_instance(
        type: ET.get(:ACCOUNT_STATUS),
        message: 'account error',
        code: EC.get(:SUBSCRIPTION_INACTIVE)
      )
      assert_instance_of E::AccountStatusError, err
    end

    it 'creates SecurityError for security type' do
      err = E.create_error_instance(
        type: ET.get(:SECURITY),
        message: 'security error',
        code: EC.get(:UNAUTHORIZED)
      )
      assert_instance_of E::SecurityError, err
    end

    it 'creates RateLimitError for system type with rate_limit_exceeded code' do
      config = ShipEngineRb::Configuration.new(api_key: 'test', retries: 3)
      err = E.create_error_instance(
        type: ET.get(:SYSTEM),
        message: 'rate limited',
        code: EC.get(:RATE_LIMIT_EXCEEDED),
        config:
      )
      assert_instance_of E::RateLimitError, err
      assert_equal 3, err.retries
    end

    it 'creates RateLimitError safely when config is nil' do
      err = E.create_error_instance(
        type: ET.get(:SYSTEM),
        message: 'rate limited',
        code: EC.get(:RATE_LIMIT_EXCEEDED),
        config: nil
      )
      assert_instance_of E::RateLimitError, err
      assert_nil err.retries
    end

    it 'creates TimeoutError for system type with timeout code' do
      err = E.create_error_instance(
        type: ET.get(:SYSTEM),
        message: 'timed out',
        code: EC.get(:TIMEOUT)
      )
      assert_instance_of E::TimeoutError, err
    end

    it 'creates generic SystemError for other system codes' do
      err = E.create_error_instance(
        type: ET.get(:SYSTEM),
        message: 'system error',
        code: EC.get(:UNSPECIFIED)
      )
      assert_instance_of E::SystemError, err
      refute_instance_of E::RateLimitError, err
      refute_instance_of E::TimeoutError, err
    end

    it 'creates generic ShipEngineError for unknown types' do
      err = E.create_error_instance(
        type: 'unknown_type',
        message: 'unknown error',
        code: EC.get(:UNSPECIFIED)
      )
      assert_instance_of E::ShipEngineError, err
    end
  end

  describe '.create_invalid_field_value_error' do
    it 'creates a ValidationError with INVALID_FIELD_VALUE code' do
      err = E.create_invalid_field_value_error('bad value')
      assert_instance_of E::ValidationError, err
      assert_equal EC.get(:INVALID_FIELD_VALUE), err.code
      assert_equal 'bad value', err.message
    end
  end

  describe '.create_required_error' do
    it 'creates a ValidationError with FIELD_VALUE_REQUIRED code' do
      err = E.create_required_error('api_key')
      assert_instance_of E::ValidationError, err
      assert_equal EC.get(:FIELD_VALUE_REQUIRED), err.code
      assert_match(/api_key must be specified/, err.message)
    end
  end

  describe '.create_invariant_error' do
    it 'creates a SystemError with UNSPECIFIED code and INVARIANT prefix' do
      err = E.create_invariant_error('something impossible happened')
      assert_instance_of E::SystemError, err
      assert_equal EC.get(:UNSPECIFIED), err.code
      assert_match(/INVARIANT ERROR/, err.message)
    end
  end

  describe 'ErrorCode' do
    it '.get returns the code for a known key' do
      assert_equal 'rate_limit_exceeded', EC.get(:RATE_LIMIT_EXCEEDED)
    end

    it '.get_by_str resolves a string key' do
      assert_equal 'rate_limit_exceeded', EC.get_by_str('rate_limit_exceeded')
    end

    it '.get returns nil for unknown key' do
      assert_nil EC.get(:NONEXISTENT)
    end
  end

  describe 'ErrorType' do
    it '.get returns the type for a known key' do
      assert_equal 'validation', ET.get(:VALIDATION)
    end

    it '.get_by_str resolves a string key' do
      assert_equal 'validation', ET.get_by_str('validation')
    end

    it '.get returns nil for unknown key' do
      assert_nil ET.get(:NONEXISTENT)
    end
  end
end
