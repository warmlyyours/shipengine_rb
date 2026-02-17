# frozen_string_literal: true

require 'minitest/assertions'

module CustomAssertions
  include Minitest::Assertions

  def assert_within_secs_from_now(secs, time)
    diff = Time.now - time
    assert_operator(diff, :<, secs, "should be #{secs} from now. Got diff: #{diff}")
  end

  def assert_content_type_json(headers)
    assert_match(%r{application/json}i, fuzzy_get_header('Content-Type', headers), "should have content-type application/json. headers #{headers}")
  end

  def assert_between(greater_than_this_value, less_than_this_value, value, field = 'value')
    assert(
      value > greater_than_this_value && value < less_than_this_value,
      "#{field} should be between #{greater_than_this_value} and #{less_than_this_value}. Got #{value}"
    )
  end

  def assert_equal_value(key, value1, value2)
    assert_equal(value1, value2, "-> #{key}")
  end

  def assert_equal_fields(some_hash, some_class)
    some_hash.each_key do |symbol|
      assert_equal(some_hash[symbol], some_class.send(symbol), "-> #{symbol}") if expected_event.key?(symbol)
    end
  end

  # @param expected [Hash]
  # @param actual [Hash] - raw hash response with 'package' key
  def assert_track_package_result(expected, actual)
    raise 'no package' unless actual['package']

    assert_equal_value('package_id', expected[:package_id], actual['package']['package_id']) if expected[:package_id]
  end

  def assert_jsonrpc_method_in_body(method, body)
    assert_equal(body['method'], method)
  end

  def assert_response_error(expected_err, response_err)
    if expected_err.key?(:message)
      assert_equal(
        expected_err[:message],
        response_err.to_s
      ) && assert_equal(expected_err[:message], response_err.message)
    end
    assert_equal(expected_err[:code], response_err.code) if expected_err.key?(:code)
    assert_equal(expected_err[:source], response_err.source) if expected_err.key?(:source)
    assert_equal(expected_err[:type], response_err.type) if expected_err.key?(:type)
    assert_equal(expected_err[:url], response_err.url) if expected_err.key?(:url)
    assert_request_id_equal(expected_err[:request_id], response_err.request_id) if expected_err.key?(:request_id)
  end

  def assert_request_id_format(id)
    assert_match(/^req_\w+$/, id, 'request_id invalid.')
  end

  def assert_request_id_equal(expected_id, response_id)
    if expected_id.nil?
      assert_nil(response_id)
    elsif expected_id == :__REGEX_MATCH__
      assert_request_id_format(response_id)
    else
      assert_equal(expected_id, response_id)
    end
  end

  def assert_raises_shipengine(error_class, expected_err, &)
    err = assert_raises(error_class, &)
    assert_response_error(expected_err, err)
    err
  end

  def assert_raises_shipengine_validation(expected_err, &)
    copy_expected_err = expected_err.clone
    copy_expected_err[:source] = 'shipengine'
    copy_expected_err[:type] = 'validation'
    assert_raises_shipengine(ShipEngineRb::Exceptions::ValidationError, copy_expected_err, &)
  end

  def assert_raises_shipengine_timeout(expected_err, &)
    copy_expected_err = expected_err.clone
    copy_expected_err[:source] = 'shipengine'
    copy_expected_err[:type] = 'system'
    copy_expected_err[:url] = URI('https://www.shipengine.com/docs/rate-limits')
    copy_expected_err[:request_id] = :__REGEX_MATCH__
    assert_raises_shipengine(ShipEngineRb::Exceptions::TimeoutError, copy_expected_err, &)
  end

  def assert_validated_address(expected_address, response_address)
    raise 'address_line1 is a required key.' unless expected_address[:address_line1]

    assert_equal(expected_address[:address_line1], response_address['address_line1'], '-> address_line1') if expected_address.key?(:address_line1)
    assert_equal(expected_address[:address_line2], response_address['address_line2'], '-> address_line2') if expected_address.key?(:address_line2) && expected_address[:address_line2]
    assert_equal(expected_address[:address_line3], response_address['address_line3'], '-> address_line3') if expected_address.key?(:address_line3) && expected_address[:address_line3]
    assert_equal(expected_address[:name], response_address['name'], '-> name') if expected_address.key?(:name) && expected_address[:name]
    assert_equal(expected_address[:company_name], response_address['company_name'], '-> company_name') if expected_address.key?(:company_name) && expected_address[:company_name]
    assert_equal(expected_address[:phone], response_address['phone'], '-> phone') if expected_address.key?(:phone) && expected_address[:phone]
    assert_equal(expected_address[:city_locality], response_address['city_locality'], '-> city_locality') if expected_address.key?(:city_locality) && expected_address[:city_locality]
    assert_equal(expected_address[:state_province], response_address['state_province'], '-> state_province') if expected_address.key?(:state_province) && expected_address[:state_province]
    assert_equal(expected_address[:postal_code], response_address['postal_code'], '-> postal_code') if expected_address.key?(:postal_code) && expected_address[:postal_code]
    assert_equal(expected_address[:country_code], response_address['country_code'], '-> country_code') if expected_address.key?(:country_code) && expected_address[:country_code]
    return unless expected_address.key?(:address_residential_indicator) && expected_address[:address_residential_indicator]

    assert_equal(
      expected_address[:address_residential_indicator],
      response_address['address_residential_indicator'],
      '-> address_residential_indicator'
    )
  end

  # @param expected_result [Hash]
  # @param response_result [Hash] - raw hash response
  def assert_address_validation_result(expected_result, response_result)
    assert_equal(expected_result[:status], response_result['status']) if expected_result.key?(:status)
    assert_messages_equals(expected_result[:messages], response_result['messages']) if expected_result.key?(:messages)

    return assert_nil(response_result['matched_address'], '~> matched_address') if expected_result.key?(:matched_address) && expected_result[:matched_address].nil?

    expected_address_original = expected_result[:original_address]
    expected_address_matched = expected_result[:matched_address]
    assert_validated_address(expected_address_original, response_result['original_address'])
    assert_validated_address(expected_address_matched, response_result['matched_address'])
  end

  def assert_raises_rate_limit_error(retries: nil, &block)
    err = assert_raises_shipengine(
      ShipEngineRb::Exceptions::RateLimitError,
      {
        code: 'rate_limit_exceeded',
        message: 'You have exceeded the rate limit.',
        source: 'shipengine'
      },
      &block
    )

    assert_equal(retries, err.retries, 'Retries should be the same') unless retries.nil?
  end

  # @param expected_messages [Array<Hash>]
  # @param response_messages [Array<Hash>] - array of raw message hashes
  def assert_messages_equals(expected_messages, response_messages)
    assert_equal(
      expected_messages.length,
      response_messages.length,
      "expected_messages and response_messages should be the same length. expected: #{expected_messages}, response: #{response_messages}"
    )
    expected_messages.each_with_index do |message, idx|
      r_msg = response_messages[idx]
      assert_equal(message.fetch(:code), r_msg['code'])
      assert_equal(message.fetch(:type), r_msg['type'])
      assert_equal(message.fetch(:message), r_msg['message'])
    end
  end

  # @param number [Int] - number of times spy method should be called
  # @param spy [Spy] - spy from "Spy" library
  def assert_called(number, spy)
    assert_equal(number, spy.calls.count, "Should be called #{number} times.")
  end

  def assert_tracking_events_in_order(events)
    previous_date_time = events[0]['datetime']
    events.each do |event|
      status = event['status']
      assert(
        event['datetime'] >= previous_date_time,
        "Event #{status} has an earlier timestamp that #{previous_date_time}"
      )
      previous_date_time = event['datetime']
    end
  end

  def assert_delivery_date_match(result)
    assert_equal(
      result['shipment']['actual_delivery_date'],
      result['events'][-1]['datetime'],
      'The actual_delivery_datetime'
    )
  end

  def assert_valid_iso_string(iso_string)
    !iso_string[ShipEngineRb::Constants::VALID_ISO_STRING].nil?
  end

  def assert_valid_iso_string_with_no_tz(iso_string)
    !iso_string[ShipEngineRb::Constants::VALID_ISO_STRING_WITH_NO_TZ].nil?
  end
end
